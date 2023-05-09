import 'package:dartz/dartz.dart';

abstract class StreamGpsUsecase {
  Future<Either<Exception,void>> call(bool isStreaming);
}