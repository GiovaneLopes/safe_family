import 'package:dartz/dartz.dart';

abstract class RecoverPasswordDatasource {
  Future<Either<Exception, void>> call(String email);
}
