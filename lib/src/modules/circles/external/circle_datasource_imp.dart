import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/infra/circle_datasource.dart';

class CircleDatasourceImp implements CircleDatasource {
  late final FirebaseAuth firebaseAuth;
  late final FirebaseDatabase firebaseDatabase;

  CircleDatasourceImp() {
    firebaseAuth = FirebaseAuth.instance;
    firebaseDatabase = FirebaseDatabase.instance;
  }

  @override
  Future<Either<Exception, CircleEntity>> getCircle() async {
    try {
      final userAuth = firebaseAuth.currentUser;
      final profile = await getUserProfile(userAuth!.uid);
      if (profile.circleCode != null && profile.circleCode!.isNotEmpty) {
        final circle = await getUserCircles(profile.circleCode!);
        return Right(circle);
      }

      return Right(CircleEntity.empty());
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

  @override
  Future<Either<Exception, CircleEntity>> setCircle(String code) async {
    try {
      final userAuth = firebaseAuth.currentUser;
      await setUserCircle(userAuth!.uid, code);
      final profile = await getUserProfile(userAuth.uid);
      if (profile.circleCode != null && profile.circleCode!.isNotEmpty) {
        final circle = await getUserCircles(profile.circleCode!);
        return Right(circle);
      }
      return Right(CircleEntity.empty());
    } on FirebaseException {
      rethrow;
    }
  }

  Future setUserCircle(String uid, String code) async {
    try {
      DatabaseReference userRef =
          firebaseDatabase.ref().child('users').child(uid);
      userRef.child('circleCode').set(code);
      final profile = await getUserProfile(uid);
      DatabaseReference circlesRef =
          firebaseDatabase.ref().child('circles').child(code).child(uid);
      await circlesRef.set({
        'uid': profile.uid,
        'name': profile.name,
        'email': profile.email,
        'phone': profile.phone,
        'photoUrl': profile.photoUrl,
        'pinUrl': profile.pinUrl,
        'circleCode': null
      });
    } on FirebaseException {
      rethrow;
    }
  }
}
