import 'package:dartz/dartz.dart';

abstract class ResendVerificationEmailUsecase {
  Future<Either<Exception, void>> call();
}
