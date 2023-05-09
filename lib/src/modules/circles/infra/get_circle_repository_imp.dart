import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/repositories/get_circle_repository.dart';
import 'package:safe_lopes_family/src/modules/circles/infra/circle_datasource.dart';

class GetCircleRepositoryImp implements GetCircleRepository {
  final CircleDatasource circleDatasource;

  GetCircleRepositoryImp(this.circleDatasource);

  @override
  Future<Either<Exception, CircleEntity>> call() async {
    return await circleDatasource.getCircle();
  }
}
