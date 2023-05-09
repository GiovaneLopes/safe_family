import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';

abstract class CircleDatasource {
  Future<Either<Exception, CircleEntity>> getCircle();
  Future<Either<Exception, CircleEntity>> setCircle(String code);
}
