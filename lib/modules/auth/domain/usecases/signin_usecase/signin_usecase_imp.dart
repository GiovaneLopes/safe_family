import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/auth/domain/repositories/signin_repository/signin_respository.dart';
import 'package:safe_lopes_family/modules/auth/domain/usecases/signin_usecase/signin_usecase.dart';

class SigninUsecaseImp implements SigninUsecase {
  final SigninRepository signinRepository;

  SigninUsecaseImp(this.signinRepository);

  @override
  Future<Either<Exception, void>> call(String email, String password) async {
    return await signinRepository(email, password);
  }
}
