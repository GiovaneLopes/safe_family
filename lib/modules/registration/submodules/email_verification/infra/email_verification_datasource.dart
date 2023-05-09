import 'package:dartz/dartz.dart';

abstract class EmailVerificationDatasource {
  Future<Either<Exception, void>> emailVerification();
  Future<Either<Exception, void>> resendEmailVerification();
}
