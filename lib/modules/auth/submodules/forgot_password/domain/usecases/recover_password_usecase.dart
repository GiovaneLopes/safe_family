import 'package:dartz/dartz.dart';

abstract class RecoverPasswordUsecase {
  Future<Either<Exception, void>> call(String email);
}
