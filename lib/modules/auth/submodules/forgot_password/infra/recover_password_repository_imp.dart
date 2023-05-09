import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/domain/repositories/recover_password_repository.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/infra/recover_password_datasource.dart';

class RecoverPasswordRepositoryImp implements RecoverPasswordRepository {
  final RecoverPasswordDatasource recoverPasswordDatasource;

  RecoverPasswordRepositoryImp(this.recoverPasswordDatasource);

  @override
  Future<Either<Exception, void>> call(String email) async {
    try {
      return await recoverPasswordDatasource(email);
    } catch (e) {
      rethrow;
    }
  }
}
