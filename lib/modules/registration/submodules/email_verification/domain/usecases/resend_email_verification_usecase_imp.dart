import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/repositories/resend_email_verification_repository.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/usecases/resend_email_verification_usecase.dart';

class ResendVerificationEmailUsecaseImp
    implements ResendVerificationEmailUsecase {
  final ResendEmailVerificationRepository resendEmailVerificationRepository;

  ResendVerificationEmailUsecaseImp(this.resendEmailVerificationRepository);

  @override
  Future<Either<Exception, void>> call() async {
    return await resendEmailVerificationRepository();
  }
}
