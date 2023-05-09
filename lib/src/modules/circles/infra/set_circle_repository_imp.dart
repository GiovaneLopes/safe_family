import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/repositories/set_circle_repository.dart';
import 'package:safe_lopes_family/src/modules/circles/infra/circle_datasource.dart';

class SetCircleRepositoryImp implements SetCircleRepository {
  final CircleDatasource circleDatasource;

  SetCircleRepositoryImp(this.circleDatasource);

  @override
  Future<Either<Exception, CircleEntity>> call(String code) async {
    return await circleDatasource.setCircle(code);
  }
}
