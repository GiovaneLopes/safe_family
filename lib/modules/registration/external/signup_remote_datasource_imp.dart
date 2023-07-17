import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/modules/registration/infra/signup_remote_datasource.dart';

class SignupRemoteDatasourceImp implements SignupRemoteDatasource {
  late final FirebaseAuth firebaseAuth;
  late final FirebaseDatabase firebaseDatabase;
  late final FirebaseStorage firebaseStorage;

  SignupRemoteDatasourceImp() {
    firebaseAuth = FirebaseAuth.instance;
    firebaseDatabase = FirebaseDatabase.instance;
    firebaseStorage = FirebaseStorage.instance;
  }

  @override
  Future<Either<Exception, void>> call(UserEntity userEntity, String password,
      XFile picture, XFile pinImage) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: userEntity.email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(userEntity.name);
        await user.sendEmailVerification();
        await reloadUser();
      }
      final photoUrl =
          await setUserProfilePicture(picture, userCredential.user!.uid);
      final pinUrl = await setUserProfilePicture(
          pinImage, '${userCredential.user!.uid}pin');
      await storeUserProfile(userCredential,
          userEntity.copyWith(photoUrl: photoUrl, pinUrl: pinUrl));
      return const Right(null);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> setUserProfilePicture(XFile picture, String fileName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final userImageRef = storageRef.child('user_image/$fileName');
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${picture.name}';
      await picture.saveTo(imagePath);
      File file = File(imagePath);
      await userImageRef.putFile(file);
      return await userImageRef.getDownloadURL();
    } on FirebaseException {
      rethrow;
    }
  }

  Future storeUserProfile(
      UserCredential userCredential, UserEntity userEntity) async {
    try {
      DatabaseReference userRef =
          firebaseDatabase.ref().child('users').child(userCredential.user!.uid);
      String unFormattedPhone = userEntity.phone
          .replaceAll(RegExp(r'[^\w\s]+'), '')
          .replaceAll(' ', '')
          .replaceAll('-', '');
      await userRef.set({
        'uid': userCredential.user!.uid,
        'name': userEntity.name,
        'email': userEntity.email,
        'phone': unFormattedPhone,
        'photoUrl': userEntity.photoUrl,
        'pinUrl': userEntity.pinUrl,
      });
    } on FirebaseException {
      rethrow;
    }
  }

  Future<void> reloadUser() async {
    await firebaseAuth.currentUser!.reload();
  }
}
