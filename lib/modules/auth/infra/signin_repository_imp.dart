import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/auth/domain/repositories/signin_repository/signin_respository.dart';
import 'package:safe_lopes_family/modules/auth/infra/signin_remote_datasource.dart';

class SigninRepositoryImp implements SigninRepository {
  final SigninRemoteDataSource signinRemoteDataSource;

  SigninRepositoryImp(this.signinRemoteDataSource);

  @override
  Future<Either<Exception, void>> call(String email, String password) async {
    return await signinRemoteDataSource(email, password);
  }
}
