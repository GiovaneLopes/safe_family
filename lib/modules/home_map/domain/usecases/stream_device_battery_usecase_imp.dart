import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/home_map/domain/repositories/stream_device_battery_repository.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/stream_device_battery_usecase.dart';

class StreamDeviceBatteryUsecaseImp implements StreamDeviceBatteryUsecase {
  final StreamDeviceBatteryRepository streamDeviceBatteryRepository;

  StreamDeviceBatteryUsecaseImp(this.streamDeviceBatteryRepository);

  @override
  Future<Either<Exception, void>> call(int batteryLevel) async {
    return await streamDeviceBatteryRepository(batteryLevel);
  }
}
