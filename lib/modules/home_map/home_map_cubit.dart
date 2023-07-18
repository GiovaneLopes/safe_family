import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/listen_circle_location_usecase.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/sign_out_usecase.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/stream_device_battery_usecase_imp.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/stream_gps_usecase.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/get_circle_usecase.dart';
import 'package:safe_lopes_family/src/modules/user/domain/usecases/get_user_usecase.dart';

class HomeMapCubit extends Cubit<HomeMapState> {
  final StreamGpsUsecase streamGpsUsecase;
  final ListenCircleLocationUsecase listenCircleLocationUsecase;
  final GetCircleUsecase getCircleDataUsecase;
  final SignOutUsecase signOutUseCase;
  final GetUserUsecase getUserUsecase;
  final StreamDeviceBatteryUsecaseImp streamDeviceBatteryUsecaseImp;
  HomeMapCubit(
      this.streamGpsUsecase,
      this.listenCircleLocationUsecase,
      this.getCircleDataUsecase,
      this.signOutUseCase,
      this.getUserUsecase,
      this.streamDeviceBatteryUsecaseImp)
      : super(HomeMapInitialState());
  final Stream<Position> devicePosition = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
  late GoogleMapController? mapController;
  late String mapTheme;
  late UserEntity userEntity;
  StreamSubscription<Position>? devicePositionStream;
  UserEntity? selectedUser;
  List<UserEntity> dropdownUsers = [];
  bool isStreamingLocation = false;
  late Set<Marker> markers = <Marker>{};
  late List<UserEntity> users;

  Future<void> initialize() async {
    try {
      //Get User Entity
      final response = await getUserEntity();
      response.fold((l) => emit(HomeMapErrorState('Erro do servidor')),
          (r) async {
        userEntity = r;
        users = [userEntity];
      });

      //Get Circle Data
      final circleResponse = await getCircleData();
      circleResponse.fold((l) => emit(HomeMapErrorState('Erro do servidor')),
          (value) {
        if (value.users.isNotEmpty && value.code.isNotEmpty) {
          dropdownUsers.clear();
          dropdownUsers = value.users;
          // Listen Circle Users Locations
          listenCircleLocationData(value.code);
          // Battery level
          listenDeviceBatteryLevel();
        } else {
          emit(HomeMapSuccessState(markers, users, isStreamingLocation));
        }
      });
    } on FirebaseException catch (e) {
      emit(HomeMapErrorState(e.message ?? 'Algo deu errado'));
    } on FlutterError catch (e) {
      emit(HomeMapErrorState(e.message));
    }
  }

  Future<Either<Exception, UserEntity>> getUserEntity() async {
    return await getUserUsecase();
  }

  Future<Either<Exception, CircleEntity>> getCircleData() async {
    return await getCircleDataUsecase();
  }

  Future<void> onLocationData(Position position) async {
    if (userEntity.circleCode != null && userEntity.circleCode!.isNotEmpty) {
      // Stream Device Location To Circle
      sendDeviceLocation(position);
    } else {
      // Show Device Location On Map
      markers = await buildUsersMarkers([
        userEntity.copyWith(
          latitude: position.latitude,
          longitude: position.longitude,
        )
      ]);
      users = [userEntity];
      emit(HomeMapSuccessState(markers, users, isStreamingLocation));
    }
  }

  void listenDeviceBatteryLevel() async {
    if (Platform.isAndroid) {
      BatteryInfoPlugin()
          .androidBatteryInfoStream
          .listen(listenAndroidBatteryLevel);
    } else if (Platform.isIOS) {
      BatteryInfoPlugin().iosBatteryInfoStream.listen(listenIOSdBatteryLevel);
    }
  }

  Future<void> listenAndroidBatteryLevel(AndroidBatteryInfo? event) async {
    if (userEntity.circleCode != null && userEntity.circleCode!.isNotEmpty) {
      // Stream Device Battery Level
      if (event != null) {
        sendDeviceBatteryLevel(event.batteryLevel ?? 0);
      }
    } else {
      // Show Device Battery
      if (event != null) {
        markers = await buildUsersMarkers(
            [userEntity = userEntity.copyWith(battery: event.batteryLevel)]);
        users = [userEntity];
        emit(HomeMapSuccessState(markers, users, isStreamingLocation));
      }
    }
  }

  Future<void> listenIOSdBatteryLevel(IosBatteryInfo? event) async {
    if (userEntity.circleCode != null && userEntity.circleCode!.isNotEmpty) {
      // Stream Device Battery Level
      if (event != null) {
        sendDeviceBatteryLevel(event.batteryLevel ?? 0);
      }
    } else {
      // Show Device Battery
      if (event != null) {
        markers = await buildUsersMarkers(
            [userEntity = userEntity.copyWith(battery: event.batteryLevel)]);
        users = [userEntity];
        emit(HomeMapSuccessState(markers, users, isStreamingLocation));
      }
    }
  }

  Future<void> listenCircleLocationData(String code) async {
    listenCircleLocationUsecase(code).listen((list) async {
      markers = await buildUsersMarkers(list);
      users = list;
      emit(HomeMapSuccessState(markers, users, isStreamingLocation));
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
          animateCameraSelectedUser(user);
        }
      }).toSet(),
    );
    return markers;
  }

  Future<void> sendDeviceBatteryLevel(int batteryLevel) async {
    await streamDeviceBatteryUsecaseImp(batteryLevel);
  }

  Future<void> sendDeviceLocation(Position position) async {
    // Stream Device Location
    await streamGpsUsecase(position);
  }

  Future<void> startPauseGps() async {
    if (devicePositionStream != null) {
      if (devicePositionStream!.isPaused) {
        isStreamingLocation = true;
        devicePositionStream!.resume();
        emit(HomeMapSuccessState(markers, users, isStreamingLocation));
      } else {
        isStreamingLocation = false;
        devicePositionStream!.pause();
        emit(HomeMapSuccessState(markers, users, isStreamingLocation));
      }
    } else {
      // Check Location Permission
      if (await isLocationPermissionGranted()) {
        // Stream Device Location
        devicePositionStream = devicePosition.listen(onLocationData);
        isStreamingLocation = true;
      }
    }
  }

  void animateCameraSelectedUser(UserEntity user) async {
    if (user.latitude != null && user.longitude != null) {}
    final position = CameraPosition(
        target: LatLng(user.latitude!, user.longitude!), zoom: 16);
    mapController!.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<void> signOut() async {
    if (devicePositionStream != null) {
      // Stop Streaming Device Location
      await devicePositionStream!.cancel();
    }
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
  final List<UserEntity> users;
  final bool isStreamingLocation;

  HomeMapSuccessState(this.markers, this.users, this.isStreamingLocation);
}

class HomeMapErrorState extends HomeMapState {
  final String message;
  HomeMapErrorState(this.message);
}
