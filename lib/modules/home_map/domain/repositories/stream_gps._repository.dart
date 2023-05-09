import 'package:dartz/dartz.dart';

abstract class StreamGpsRepository {
  Future<Either<Exception, void>> call(bool isStreaming);
}
