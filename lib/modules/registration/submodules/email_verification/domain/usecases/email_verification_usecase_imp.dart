import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/repositories/email_verification_repository.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/usecases/email_verification_usecase.dart';

class EmailVerificationUsecaseImp implements EmailVerificationUsecase {
  final EmailVerificationRepository emailVerificationRepository;

  EmailVerificationUsecaseImp(this.emailVerificationRepository);

  @override
  Future<Either<Exception, void>> call() async {
    return await emailVerificationRepository();
  }
}
