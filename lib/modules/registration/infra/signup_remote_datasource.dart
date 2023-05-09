import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';

abstract class SignupRemoteDatasource {
  Future<Either<Exception, void>> call(
      UserEntity userEntity, String password, XFile picture);
}
