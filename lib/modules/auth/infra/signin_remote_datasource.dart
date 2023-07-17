import 'package:dartz/dartz.dart';

abstract class SigninRemoteDataSource {
  Future<Either<Exception, void>> call(String email, String password);
}
