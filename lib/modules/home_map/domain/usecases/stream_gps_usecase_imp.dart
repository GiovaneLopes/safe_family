import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_lopes_family/modules/home_map/domain/repositories/stream_gps._repository.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/stream_gps_usecase.dart';

class StreamGpsUsecaseImp implements StreamGpsUsecase {
  final StreamGpsRepository streamGpsRepository;

  StreamGpsUsecaseImp(this.streamGpsRepository);

  @override
  Future<Either<Exception, void>> call(Position position) async {
    return await streamGpsRepository(position);
  }
}
