import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_lopes_family/modules/auth/infra/signin_remote_datasource.dart';

class SigninRemoteDataSourceImp implements SigninRemoteDataSource {
  late final FirebaseAuth firebaseAuth;

  SigninRemoteDataSourceImp() {
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Future<Either<Exception, void>> call(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return const Right(null);
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
