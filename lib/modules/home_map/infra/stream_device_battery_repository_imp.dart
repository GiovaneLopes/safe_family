import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/home_map/domain/repositories/stream_device_battery_repository.dart';
import 'package:safe_lopes_family/modules/home_map/infra/home_datasource.dart';

class StreamDeviceBatteryRepositoryImp
    implements StreamDeviceBatteryRepository {
  final HomeDatasource homeDatasource;

  StreamDeviceBatteryRepositoryImp(this.homeDatasource);

  @override
  Future<Either<Exception, void>> call(int batteryLevel) async {
    return await homeDatasource.streamDeviceBatteryLevel(batteryLevel);
  }
}
