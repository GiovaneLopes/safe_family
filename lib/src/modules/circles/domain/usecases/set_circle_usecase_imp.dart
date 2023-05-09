import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/entities/circle_entity.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/repositories/set_circle_repository.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/set_circle_usecase.dart';

class SetCircleUsecaseImp implements SetCircleUsecase {
  final SetCircleRepository setCircleRepository;

  SetCircleUsecaseImp(this.setCircleRepository);

  @override
  Future<Either<Exception, CircleEntity>> call(String code) async {
    return await setCircleRepository(code);
  }
}
