import 'package:dartz/dartz.dart';

abstract class SigninRepository {
  Future<Either<Exception, void>> call(String email, String password);
}
