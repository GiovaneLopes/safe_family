import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/infra/recover_password_datasource.dart';

class RecoverPasswordDatasourceImp implements RecoverPasswordDatasource {
  final FirebaseAuth firebaseAuth;

  RecoverPasswordDatasourceImp(this.firebaseAuth);
  @override
  Future<Either<Exception, void>> call(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(e);
    }
  }
}
