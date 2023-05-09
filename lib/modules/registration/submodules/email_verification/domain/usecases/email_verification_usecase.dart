import 'package:dartz/dartz.dart';

abstract class EmailVerificationUsecase {
  Future<Either<Exception,void>> call();
}