import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/repositories/resend_email_verification_repository.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/infra/email_verification_datasource.dart';

class ResendEmailVerificationRepositoryImp
    implements ResendEmailVerificationRepository {
  final EmailVerificationDatasource emailVerificationDatasource;

  ResendEmailVerificationRepositoryImp(this.emailVerificationDatasource);

  @override
  Future<Either<Exception, void>> call() async {
    return await emailVerificationDatasource.resendEmailVerification();
  }
}
