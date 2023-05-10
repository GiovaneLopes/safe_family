import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/auth/auth_cubit.dart';
import 'package:safe_lopes_family/modules/auth/auth_page.dart';
import 'package:safe_lopes_family/modules/auth/domain/usecases/signin_usecase/signin_usecase_imp.dart';
import 'package:safe_lopes_family/modules/auth/external/signin_remote_datasource_imp.dart';
import 'package:safe_lopes_family/modules/auth/infra/signin_repository_imp.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/forgot_password_module.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => AuthCubit(i())),
        Bind.lazySingleton((i) => SigninUsecaseImp(i())),
        Bind.lazySingleton((i) => SigninRepositoryImp(i())),
        Bind.lazySingleton((i) => SigninRemoteDataSourceImp()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const AuthPage()),
        ModuleRoute('/forgot-password', module: ForgotPasswordModule()),
      ];
}
