import 'package:dartz/dartz.dart';

abstract class SignOutUsecase {
  Future<Either<Exception, void>> call();
}
