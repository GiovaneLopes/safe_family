import 'package:safe_lopes_family/modules/home_map/domain/repositories/listen_circle_location_repository.dart';
import 'package:safe_lopes_family/modules/home_map/infra/home_datasource.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';

class ListenCircleLocationRepositoryImp
    implements ListenCircleLocationRepository {
  final HomeDatasource homeDatasource;

  ListenCircleLocationRepositoryImp(this.homeDatasource);

  @override
  Stream<List<UserEntity>> call(String circleCode) {
    return homeDatasource.listenCircleLocation(circleCode);
  }
}
