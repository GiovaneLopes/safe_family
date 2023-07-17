import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/repositories/email_verification_repository.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/infra/email_verification_datasource.dart';

class EmailVerificationRepositoryImp implements EmailVerificationRepository {
  final EmailVerificationDatasource emailVerificationDatasource;

  EmailVerificationRepositoryImp(this.emailVerificationDatasource);

  @override
  Future<Either<Exception, void>> call() async {
    return await emailVerificationDatasource.emailVerification();
  }
}
