import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';

abstract class ListenCircleLocationUsecase {
  Stream<List<UserEntity>> call(String circleCode);
}
