import 'package:safe_lopes_family/modules/home_map/domain/repositories/listen_circle_location_repository.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/listen_circle_location_usecase.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';

class ListenCircleLocationUsecaseImp implements ListenCircleLocationUsecase {
  final ListenCircleLocationRepository listenCircleLocationRepository;

  ListenCircleLocationUsecaseImp(this.listenCircleLocationRepository);

  @override
  Stream<List<UserEntity>> call(String circleCode) {
    return listenCircleLocationRepository(circleCode);
  }
}
