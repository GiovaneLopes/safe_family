import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/registration/domain/usecases/signup_usecase_imp.dart';
import 'package:safe_lopes_family/modules/registration/external/signup_remote_datasource_imp.dart';
import 'package:safe_lopes_family/modules/registration/infra/signup_repository_imp.dart';
import 'package:safe_lopes_family/modules/registration/registration_cubit.dart';
import 'package:safe_lopes_family/modules/registration/registration_page.dart';
import 'package:safe_lopes_family/modules/registration/submodules/email_verification/email_verification_module.dart';

class RegistrationModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => RegistrationCubit(i())),
        Bind.lazySingleton((i) => SignupUsecaseImp(i())),
        Bind.lazySingleton((i) => SignupRepositoryImp(i())),
        Bind.lazySingleton(
          (i) => SignupRemoteDatasourceImp(
            FirebaseAuth.instance,
            FirebaseDatabase.instance,
            FirebaseStorage.instance,
          ),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const RegistrationPage()),
        ModuleRoute('/email-verification', module: EmailVerificationModule()),
      ];
}
