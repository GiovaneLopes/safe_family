import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageService {
  // ignore: unused_field
  late FirebaseStorage _firebaseStorage;
  FirebaseStorageService() {
    _initialize();
  }

  void _initialize() {
    _firebaseStorage = FirebaseStorage.instance;
  }

  Future<String?> setUserProfilePicture(
      XFile picture, UserCredential userCredential) async {
    final storageRef = FirebaseStorage.instance.ref();
    final userImageRef =
        storageRef.child('user_image/${userCredential.user!.uid}');
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/${picture.name}';
    picture.saveTo(imagePath);
    File file = File(imagePath);
    try {
      await userImageRef.putFile(file);
      storageRef.child('user_image/${picture.name}');
      return await userImageRef.getDownloadURL();
    } on FirebaseException {
      rethrow;
    }
  }

  // Future<String> getUserProfilePicture(String pictureName) async {
  //   final storageRef = FirebaseStorage.instance.ref();
  //   final userImageRef = storageRef.child('user_image/$pictureName');
  //   try {
  //     final url = await userImageRef.getDownloadURL();
  //     return url;
  //   } on FirebaseException {
  //     rethrow;
  //   }
  // }
}
