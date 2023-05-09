import 'package:dartz/dartz.dart';

abstract class SignOutRepository {
  Future<Either<Exception, void>> call();
}
