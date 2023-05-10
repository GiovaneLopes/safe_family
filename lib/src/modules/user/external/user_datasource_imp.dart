import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/user/infra/user_datasource.dart';

class UserDatasourceImp implements UserDatasource {
  late final FirebaseAuth firebaseAuth;
  late final FirebaseDatabase firebaseDatabase;

  UserDatasourceImp() {
    firebaseAuth = FirebaseAuth.instance;
    firebaseDatabase = FirebaseDatabase.instance;
  }

  User? get user => firebaseAuth.currentUser;

  @override
  Future<Either<Exception, UserEntity>> call() async {
    try {
      if (user != null) {
        DatabaseReference userRef = firebaseDatabase.ref().child('users');
        final response = await userRef.child(user!.uid).get();
        return Right(UserEntity.fromJson(jsonEncode(response.value)));
      }
      return Left(Exception());
    } on FirebaseException {
      rethrow;
    }
  }
}
