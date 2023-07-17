import 'package:camera/camera.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/domain/repositories/signup_repository.dart';
import 'package:safe_lopes_family/modules/registration/domain/usecases/signup_usecase.dart';

class SignupUsecaseImp implements SignupUsecase {
  final SignupRepository signupRepository;

  SignupUsecaseImp(this.signupRepository);

  @override
  Future<Either<Exception, void>> call(UserEntity userEntity, String password,
      XFile picture, XFile pinImage) async {
    return await signupRepository(userEntity, password, picture, pinImage);
  }
}
