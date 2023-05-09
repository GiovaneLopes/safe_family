import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/home_map/domain/repositories/stream_gps._repository.dart';
import 'package:safe_lopes_family/modules/home_map/infra/home_datasource.dart';

class StreamGpsRepositoryImp implements StreamGpsRepository {
  final HomeDatasource homeDatasource;

  StreamGpsRepositoryImp(this.homeDatasource);

  @override
  Future<Either<Exception, void>> call(bool isStreaming) async {
    return await homeDatasource.streamMyLocation(isStreaming);
  }
}
