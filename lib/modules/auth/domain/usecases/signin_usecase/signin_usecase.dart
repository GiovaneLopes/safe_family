import 'package:dartz/dartz.dart';

abstract class SigninUsecase {
  Future<Either<Exception, void>> call(String email, String password);
}
