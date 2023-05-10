import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

abstract class StreamGpsUsecase {
  Future<Either<Exception, void>> call(Position position);
}
