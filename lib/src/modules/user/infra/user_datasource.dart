import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';

abstract class UserDatasource {
  Future<Either<Exception, UserEntity>> call();
}