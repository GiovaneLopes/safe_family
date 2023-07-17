import 'package:dartz/dartz.dart';

abstract class StreamDeviceBatteryRepository {
  Future<Either<Exception, void>> call(int batteryLevel);
}
