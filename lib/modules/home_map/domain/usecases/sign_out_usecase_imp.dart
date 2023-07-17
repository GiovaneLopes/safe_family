import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/home_map/domain/repositories/sign_out_respoitory.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/sign_out_usecase.dart';

class SignOutUsecaseImp implements SignOutUsecase {
  final SignOutRepository signOutRepository;

  SignOutUsecaseImp(this.signOutRepository);

  @override
  Future<Either<Exception, void>> call() async {
    return await signOutRepository();
  }
}
