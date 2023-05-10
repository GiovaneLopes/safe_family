import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';
import 'package:safe_lopes_family/src/modules/user/domain/repositories/get_user_repository.dart';
import 'package:safe_lopes_family/src/modules/user/domain/usecases/get_user_usecase.dart';

class GetUserUsecaseImp implements GetUserUsecase {
  final GetUserRepository getUserRepository;

  GetUserUsecaseImp(this.getUserRepository);
  @override
  Future<Either<Exception, UserEntity>> call() async {
    return await getUserRepository();
  }
}
