import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';

abstract class HomeDatasource {
  Stream<List<UserEntity>> listenCircleLocation(String circleCode);
  Future<Either<Exception, void>> streamMyLocation(Position position);
  Future<Either<Exception, void>> signOut();
}
