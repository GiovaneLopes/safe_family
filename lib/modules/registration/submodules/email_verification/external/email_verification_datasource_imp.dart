import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/infra/email_verification_datasource.dart';

class EmailVerificationDatasourceImp implements EmailVerificationDatasource {
  final FirebaseAuth firebaseAuth;

  EmailVerificationDatasourceImp(this.firebaseAuth);

  @override
  Future<Either<Exception, void>> emailVerification() async {
    try {
      await firebaseAuth.currentUser!.reload();
      return const Right(null);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Exception, void>> resendEmailVerification() async {
    try {
      await firebaseAuth.currentUser!.sendEmailVerification();
      return const Right(null);
    } catch (e) {
      rethrow;
    }
  }
}
