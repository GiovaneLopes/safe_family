import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/domain/repositories/recover_password_repository.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/domain/usecases/recover_password_usecase.dart';

class RecoverPasswordUsecaseImp implements RecoverPasswordUsecase {
  final RecoverPasswordRepository recoverPasswordRepository;

  RecoverPasswordUsecaseImp(this.recoverPasswordRepository);

  @override
  Future<Either<Exception, void>> call(String email) async {
    try {
      return await recoverPasswordRepository(email);
    } catch (e) {
      rethrow;
    }
  }
}
