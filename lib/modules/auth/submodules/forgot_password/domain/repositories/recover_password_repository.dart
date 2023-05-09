import 'package:dartz/dartz.dart';

abstract class RecoverPasswordRepository {
  Future<Either<Exception, void>> call(String email);
}
