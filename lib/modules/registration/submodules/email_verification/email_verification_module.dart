import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/usecases/email_verification_usecase_imp.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/domain/usecases/resend_email_verification_usecase_imp.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/email_verification_cubit.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/email_verification_page.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/external/email_verification_datasource_imp.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/infra/email_verification_repository_imp.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/infra/resend_email_verification_repository_imp.dart';

class EmailVerificationModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => EmailVerificationCubit(i(), i())),
        Bind.lazySingleton((i) => EmailVerificationUsecaseImp(i())),
        Bind.lazySingleton((i) => EmailVerificationRepositoryImp(i())),
        Bind.lazySingleton(
            (i) => EmailVerificationDatasourceImp(FirebaseAuth.instance)),
        Bind.lazySingleton((i) => ResendVerificationEmailUsecaseImp(i())),
        Bind.lazySingleton((i) => ResendEmailVerificationRepositoryImp(i())),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const EmailVerificationPage())
      ];
}
