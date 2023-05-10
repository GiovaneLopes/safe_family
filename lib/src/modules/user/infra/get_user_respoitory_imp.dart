import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/user/domain/repositories/get_user_repository.dart';
import 'package:safe_lopes_family/src/modules/user/infra/user_datasource.dart';

class GetUserRepositoryImp implements GetUserRepository {
  final UserDatasource userDatasource;

  GetUserRepositoryImp(this.userDatasource);

  @override
  Future<Either<Exception, UserEntity>> call() async {
    return await userDatasource();
  }
}
