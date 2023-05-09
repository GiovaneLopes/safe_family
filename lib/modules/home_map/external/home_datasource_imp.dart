import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_lopes_family/modules/home_map/infra/home_datasource.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';

class HomeDatasourceImp implements HomeDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;

  HomeDatasourceImp(this.firebaseAuth, this.firebaseDatabase) {
    positionStream = Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high))
        .listen(onLocationStreamData);
  }

  late StreamSubscription<Position> positionStream;

  @override
  Stream<List<UserEntity>> listenCircleLocation(String circleCode) {
    return firebaseDatabase
        .ref()
        .child('circles')
        .child(circleCode)
        .onValue
        .map((result) {
      final map = result.snapshot.value as Map<dynamic, dynamic>;
      List<UserEntity> users = [];
      map.forEach((key, value) {
        users.add(UserEntity.fromJson(jsonEncode(value)));
      });
      return users;
    });
  }

  Future<CircleEntity> getUserCircles(String code) async {
    try {
      DatabaseReference userRef =
          firebaseDatabase.ref().child('circles').child(code);
      final result = await userRef.get();
      final map = result.value as Map<dynamic, dynamic>;
      List<UserEntity> users = [];
      map.forEach((key, value) {
        users.add(UserEntity.fromJson(jsonEncode(value)));
      });
      return CircleEntity(code: code, users: users);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<UserEntity> getUserProfile(String uid) async {
    try {
      DatabaseReference userRef = firebaseDatabase.ref().child('users');
      final response = await userRef.child(uid).get();
      final user = UserEntity.fromJson(jsonEncode(response.value));
      return user;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<Either<Exception, void>> streamMyLocation(bool isStreaming) async {
    try {
      if (isStreaming == true) {
        positionStream.resume();
      } else {
        positionStream.pause();
      }
      return const Right(null);
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> onLocationStreamData(Position position) async {
    final userAuth = firebaseAuth.currentUser;
    final profile = await getUserProfile(userAuth!.uid);
    if (profile.circleCode != null && profile.circleCode!.isNotEmpty) {
      DatabaseReference circlesRef = firebaseDatabase
          .ref()
          .child('circles')
          .child(profile.circleCode!)
          .child(profile.uid!);
      await circlesRef.update({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    }
  }

  @override
  Future<Either<Exception, void>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return const Right(null);
    } on FirebaseException {
      rethrow;
    }
  }
}
