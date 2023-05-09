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

class HomeMapCubit extends Cubit<HomeMapState> {
  final StreamGpsUsecase streamGpsUsecase;
  final ListenCircleLocationUsecase listenCircleLocationUsecase;
  final GetCircleUsecase getCircleUsecase;
  final SignOutUsecase signOutUseCase;
  HomeMapCubit(this.streamGpsUsecase, this.listenCircleLocationUsecase,
      this.getCircleUsecase, this.signOutUseCase)
      : super(HomeMapInitialState());

  late GoogleMapController? mapController;
  late String mapTheme;

  Future<void> initialize() async {
    try {
      // Request Location Permission
      final isLocationPermissionAllowed = await checkLocationPermission();
      if (isLocationPermissionAllowed == true) {
        // Stream My Location
        await myLocationStartPause(true);
      }
      final circle = await getCircleUsecase();
      // Listen Circle Users Locations
      circle.fold((l) => null, (r) {
        listenCircleLocationData(r.code);
      });
    } on FirebaseException catch (e) {
      emit(HomeMapErrorState(e.message ?? 'Algo deu errado'));
    } on FlutterError catch (e) {
      emit(HomeMapErrorState(e.message));
    }
  }

  Future<bool> checkLocationPermission() async {
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

  Future<void> listenCircleLocationData(String code) async {
    listenCircleLocationUsecase(code).listen((users) async {
      Set<Marker> markers = <Marker>{};
      await Future.wait(
        users.map((user) async {
          final icon = await getBytesFromUrl(user.photoUrl!, 250);
          if (user.latitude != null && user.longitude != null) {
            markers.add(
              Marker(
                markerId: MarkerId(user.uid!),
                position: LatLng(user.latitude!, user.longitude!),
                icon: icon,
              ),
            );
          }
        }).toSet(),
      );
      emit(HomeMapSuccessState(markers, users));
    });
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

  Future<void> myLocationStartPause(bool newStreamingValue) async {
    print('### newValue: $newStreamingValue');
    await streamGpsUsecase(newStreamingValue);
  }

  Future<void> signOut() async {
    // Stop Streaming My Location
    await myLocationStartPause(false);
    // Sign out
    await signOutUseCase();
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
}

abstract class HomeMapState {}

class HomeMapLoadingState extends HomeMapState {}

class HomeMapInitialState extends HomeMapState {}

class HomeMapSuccessState extends HomeMapState {
  final Set<Marker> markers;
  final List<UserEntity> users;

  HomeMapSuccessState(this.markers, this.users);
}

class HomeMapErrorState extends HomeMapState {
  final String message;
  HomeMapErrorState(this.message);
}
