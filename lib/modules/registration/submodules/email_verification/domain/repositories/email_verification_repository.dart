import 'package:dartz/dartz.dart';

abstract class EmailVerificationRepository {
  Future<Either<Exception, void>> call();
}
