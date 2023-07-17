import 'package:dartz/dartz.dart';

abstract class ResendEmailVerificationRepository {
  Future<Either<Exception, void>> call();
}
