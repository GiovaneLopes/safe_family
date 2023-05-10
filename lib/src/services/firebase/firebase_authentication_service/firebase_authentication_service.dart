import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FirebaseAuthenticationService {
  late final FirebaseAuth _firebaseAuth;
  FirebaseAuthenticationService() {
    _initialize();
    _userChangesHandler();
  }

  User? get user => _firebaseAuth.currentUser;

  void _initialize() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  void _userChangesHandler() {
    _firebaseAuth.userChanges().listen((user) {
      _defineNavigation(user);
    });
  }

  void _defineNavigation(User? user) {
    if (user == null) {
      Modular.to.navigate('/auth/');
    } else if (!user.emailVerified) {
      Modular.to.navigate('/registration/email-verification/');
    } else {
      Modular.to.navigate('/home-map/');
    }
  }

  // Future<void> reloadUser() async {

  // }

  // Future<void> resendVerificationEmail() async {
  //   await _firebaseAuth.currentUser!.sendEmailVerification();
  // }

  // Future signIn(String email, String password) async {
  //   try {
  //     await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on FirebaseAuthException {
  //     rethrow;
  //   }
  //   Modular.to.popUntil((route) => route.isFirst);
  // }

  // Future<User?> signUp(UserEntity userEntity, String password, XFile picture) async {
  //   try {
  //     UserCredential userCredential =
  //         await _firebaseAuth.createUserWithEmailAndPassword(
  //             email: userEntity.email, password: password);
  //     User? user = userCredential.user;
  //     if (user != null) {
  //       await user.updateDisplayName(userEntity.name);
  //       await user.sendEmailVerification();
  //       await reloadUser();
  //     }
  //     final photoUrl =
  //         await firebaseStorage.setUserProfilePicture(picture, userCredential);
  //     await firebaseDB.storeUserProfile(
  //         userCredential, userEntity.copyWith(photoUrl: photoUrl));
  //     return user;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future recoverPassword(String email) async {
  //   try {
  //     await _firebaseAuth.sendPasswordResetEmail(email: email);
  //   } on FirebaseAuthException {
  //     rethrow;
  //   }
  // }

  // void signOut() {
  //   _firebaseAuth.signOut();
  // }
}
