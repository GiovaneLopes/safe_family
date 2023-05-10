import 'dart:async';
import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/listen_circle_location_usecase.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/sign_out_usecase.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/stream_gps_usecase.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/get_circle_usecase.dart';
import 'package:safe_lopes_family/src/modules/user/domain/usecases/get_user_usecase.dart';

class HomeMapCubit extends Cubit<HomeMapState> {
  final StreamGpsUsecase streamGpsUsecase;
  final ListenCircleLocationUsecase listenCircleLocationUsecase;
  final GetCircleUsecase getCircleDataUsecase;
  final SignOutUsecase signOutUseCase;
  final GetUserUsecase getUserUsecase;
  HomeMapCubit(this.streamGpsUsecase, this.listenCircleLocationUsecase,
      this.getCircleDataUsecase, this.signOutUseCase, this.getUserUsecase)
      : super(HomeMapInitialState());
  final Stream<Position> devicePosition = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
  late GoogleMapController? mapController;
  late String mapTheme;
  late UserEntity userEntity;
  late StreamSubscription<Position> devicePositionStream;
  bool get isGpsEnabled => !devicePositionStream.isPaused;
  UserEntity? selectedUser;
  List<UserEntity> dropdownUsers = [];

  Future<void> initialize() async {
    try {
      //Get User Entity
      await getUserEntity();
      // Check Location Permission
      if (await isLocationPermissionGranted()) {
        // Stream Device Location
        devicePositionStream = devicePosition.listen(onLocationData);
      }
      //Get Circle
      await getCircleData();
    } on FirebaseException catch (e) {
      emit(HomeMapErrorState(e.message ?? 'Algo deu errado'));
    } on FlutterError catch (e) {
      emit(HomeMapErrorState(e.message));
    }
  }

  Future<void> getUserEntity() async {
    final user = await getUserUsecase();
    user.fold((l) => null, (r) async {
      userEntity = r;
    });
  }

  Future<void> getCircleData() async {
    final circle = await getCircleDataUsecase();
    circle.fold((l) => null, (value) {
      if (value.users.isNotEmpty && value.code.isNotEmpty) {
        dropdownUsers = value.users;
        // Listen Circle Users Locations
        listenCircleLocationData(value.code);
      }
    });
  }

  Future<void> onLocationData(Position position) async {
    if (userEntity.circleCode != null && userEntity.circleCode!.isNotEmpty) {
      // Stream Device Location To Circle
      sendDeviceLocation(position);
    } else {
      // Show Device Location On Map
      final markers = await buildUsersMarkers([
        userEntity.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        )
      ]);
      emit(HomeMapSuccessState(markers));
    }
  }

  Future<void> listenCircleLocationData(String code) async {
    listenCircleLocationUsecase(code).listen((users) async {
      final markers = await buildUsersMarkers(users);
      emit(HomeMapSuccessState(markers));
    });
  }

  Future<Set<Marker>> buildUsersMarkers(List<UserEntity> users) async {
    Set<Marker> markers = <Marker>{};
    await Future.wait(
      users.map((user) async {
        final icon = await getBytesFromUrl(user.pinUrl!, 250);
        if (user.latitude != null && user.longitude != null) {
          markers.add(
            Marker(
                markerId: MarkerId(user.uid!),
                position: LatLng(user.latitude!, user.longitude!),
                icon: icon,
                onTap: () {
                  if (dropdownUsers.isNotEmpty) {
                    selectedUser = dropdownUsers
                        .firstWhere((element) => element.uid == user.uid);
                  }
                }),
          );
        }
        if (selectedUser != null && selectedUser!.uid == user.uid) {
          animateCamera(LatLng(user.latitude!, user.longitude!));
        }
      }).toSet(),
    );
    return markers;
  }

  Future<void> sendDeviceLocation(Position position) async {
    await streamGpsUsecase(position);
  }

  void switchStreamGps() {
    if (isGpsEnabled) {
      devicePositionStream.pause();
    } else {
      devicePositionStream.resume();
    }
  }

  Future<void> signOut() async {
    // Stop Streaming Device Location
    await devicePositionStream.cancel();
    // Sign out
    await signOutUseCase();
  }

  Future<BitmapDescriptor> getBytesFromUrl(String url, int width) async {
    http.Response response = await http.get(Uri.parse(url));
    ui.Codec codec =
        await ui.instantiateImageCodec(response.bodyBytes, targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    final bytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final hour = DateTime.now().hour;
    if (hour > 18 || hour < 6) {
      controller.setMapStyle(mapTheme);
    }
  }

  animateCamera(LatLng latlng) {
    final position = CameraPosition(
      target: latlng,
      zoom: 15,
    );
    mapController!.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<bool> isLocationPermissionGranted() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.always ||
          permission != LocationPermission.whileInUse) {
        await Geolocator.requestPermission();
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.deniedForever) {
          throw FlutterError('Permita a localização do dispositivo.');
        } else if (permission == LocationPermission.denied) {
          throw FlutterError('Permita a localização do dispositivo.');
        }
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}

abstract class HomeMapState {}

class HomeMapLoadingState extends HomeMapState {}

class HomeMapInitialState extends HomeMapState {}

class HomeMapSuccessState extends HomeMapState {
  final Set<Marker> markers;

  HomeMapSuccessState(this.markers);
}

class HomeMapErrorState extends HomeMapState {
  final String message;
  HomeMapErrorState(this.message);
}
