import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';

abstract class SetCircleRepository {
  Future<Either<Exception, CircleEntity>> call(String code);
}
