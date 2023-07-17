import 'package:dartz/dartz.dart';

abstract class StreamDeviceBatteryUsecase {
  Future<Either<Exception, void>> call(int batteryLevel);
}
