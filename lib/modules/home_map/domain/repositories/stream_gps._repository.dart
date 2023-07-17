import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

abstract class StreamGpsRepository {
  Future<Either<Exception, void>> call(Position position);
}
