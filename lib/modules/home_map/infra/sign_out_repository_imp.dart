import 'package:dartz/dartz.dart';
import 'package:safe_lopes_family/modules/home_map/domain/repositories/sign_out_respoitory.dart';
import 'package:safe_lopes_family/modules/home_map/infra/home_datasource.dart';

class SignOutRepositoryImp implements SignOutRepository {
  final HomeDatasource homeDatasource;

  SignOutRepositoryImp(this.homeDatasource);

  @override
  Future<Either<Exception, void>> call() async {
    return await homeDatasource.signOut();
  }
}
