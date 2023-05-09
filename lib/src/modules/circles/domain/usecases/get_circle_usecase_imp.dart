import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/repositories/get_circle_repository.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/get_circle_usecase.dart';

class GetCircleUsecaseImp implements GetCircleUsecase {
  final GetCircleRepository getCircleRepository;

  GetCircleUsecaseImp(this.getCircleRepository);

  @override
  Future<Either<Exception, CircleEntity>> call() async {
    return await getCircleRepository();
  }
}
