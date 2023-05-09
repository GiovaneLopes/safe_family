// import 'dart:async';
// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
// import 'package:safe_lopes_family/modules/circles/domain/entities/circle_entity.dart';
// import 'package:safe_lopes_family/src/services/firebase/firebase_storage_service/firebase_storage_service.dart';

// class FirebaseDataBaseService {
//   final FirebaseStorageService firebaseStorage;
//   FirebaseDataBaseService(this.firebaseStorage) {
//     _initialize();
//   }
//   late FirebaseDatabase _firebaseDatabase;

//   late StreamSubscription<Position> positionStream;

//   void _initialize() {
//     _firebaseDatabase = FirebaseDatabase.instance;
//   }

//   Future storeUserProfile(
//       UserCredential userCredential, UserEntity userEntity) async {
//     try {
//       DatabaseReference userRef = _firebaseDatabase
//           .ref()
//           .child('users')
//           .child(userCredential.user!.uid);
//       String unFormattedPhone = userEntity.phone
//           .replaceAll(RegExp(r'[^\w\s]+'), '')
//           .replaceAll(' ', '')
//           .replaceAll('-', '');
//       await userRef.set({
//         'uid': userCredential.user!.uid,
//         'name': userEntity.name,
//         'email': userEntity.email,
//         'phone': unFormattedPhone,
//         'photo-url': userEntity.photoUrl,
//       });
//     } on FirebaseException {
//       rethrow;
//     }
//   }

//   Future<UserEntity> getUserProfile(String uid) async {
//     try {
//       DatabaseReference userRef = _firebaseDatabase.ref().child('users');
//       final response = await userRef.child(uid).get();
//       final user = UserEntity.fromJson(jsonEncode(response.value));
//       return user;
//     } on FirebaseException {
//       rethrow;
//     }
//   }

//   Future setUserCircle(String uid, String code) async {
//     try {
//       DatabaseReference userRef =
//           _firebaseDatabase.ref().child('users').child(uid);
//       userRef.child('circle-code').set(code);
//       final profile = await getUserProfile(uid);
//       DatabaseReference circlesRef =
//           _firebaseDatabase.ref().child('circles').child(code).child(uid);
//       await circlesRef.set({
//         'uid': profile.uid,
//         'name': profile.name,
//         'email': profile.email,
//         'phone': profile.phone,
//         'photo-url': profile.photoUrl,
//         'circle-code': null
//       });
//     } on FirebaseException {
//       rethrow;
//     }
//   }

//   Future<CircleEntity> getUserCircles(String code) async {
//     try {
//       DatabaseReference userRef =
//           _firebaseDatabase.ref().child('circles').child(code);
//       final result = await userRef.get();
//       final map = result.value as Map<dynamic, dynamic>;
//       List<UserEntity> users = [];
//       map.forEach((key, value) {
//         users.add(UserEntity.fromJson(jsonEncode(value)));
//       });
//       return CircleEntity(code: code, users: users);
//     } on FirebaseException {
//       rethrow;
//     }
//   }

//   Future<void> setMyLocation(String code, String uid) async {
//     DatabaseReference circlesRef =
//         _firebaseDatabase.ref().child('circles').child(code).child(uid);
//     positionStream =
//         Geolocator.getPositionStream().listen((Position position) async {
//       await circlesRef.update({
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//       });
//     });
//   }

//   Stream<List<UserEntity>> listenMyCircle(String code) {
//     return _firebaseDatabase
//         .ref()
//         .child('circles')
//         .child(code)
//         .onValue
//         .map((result) {
//       final map = result.snapshot.value as Map<dynamic, dynamic>;
//       List<UserEntity> users = [];
//       map.forEach((key, value) {
//         users.add(UserEntity.fromJson(jsonEncode(value)));
//       });
//       return users;
//     });
//   }

//   void stopSendingMyLocation() {
//     if (positionStream.isPaused) {
//       positionStream.resume();
//     } else {
//       positionStream.pause();
//     }
//   }
// }
