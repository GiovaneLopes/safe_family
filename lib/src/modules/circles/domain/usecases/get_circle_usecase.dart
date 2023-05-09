import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';

abstract class GetCircleUsecase {
  Future<Either<Exception, CircleEntity>> call();
}
