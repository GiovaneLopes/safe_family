import 'package:camera/camera.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/domain/repositories/signup_repository.dart';
import 'package:safe_lopes_family/modules/registration/infra/signup_remote_datasource.dart';

class SignupRepositoryImp implements SignupRepository {
  final SignupRemoteDatasource signupRemoteDatasource;

  SignupRepositoryImp(this.signupRemoteDatasource);

  @override
  Future<Either<Exception, void>> call(UserEntity userEntity, String password,
      XFile picture, XFile pinImage) async {
    return await signupRemoteDatasource(
        userEntity, password, picture, pinImage);
  }
}
