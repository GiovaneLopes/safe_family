import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/domain/usecases/recover_password_usecase_imp.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/external/recover_password_datasource_imp.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/forgot_password_cubit.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/forgot_password_page.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/infra/recover_password_repository_imp.dart';

class ForgotPasswordModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => ForgotPasswordCubit(i())),
        Bind.lazySingleton((i) => RecoverPasswordUsecaseImp(i())),
        Bind.lazySingleton((i) => RecoverPasswordRepositoryImp(i())),
        Bind.lazySingleton(
            (i) => RecoverPasswordDatasourceImp(FirebaseAuth.instance)),
      ];

  @override
  List<ModularRoute> get routes =>
      [ChildRoute('/', child: (context, args) => const ForgotPasswordPage())];
}
