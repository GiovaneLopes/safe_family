import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/app_cubit.dart';
import 'package:safe_lopes_family/app_widget.dart';
import 'package:safe_lopes_family/modules/auth/auth_cubit.dart';
import 'package:safe_lopes_family/modules/auth/auth_module.dart';
import 'package:safe_lopes_family/modules/auth/submodules/forgot_password/forgot_password_cubit.dart';
import 'package:safe_lopes_family/modules/circles/circles_module.dart';
import 'package:safe_lopes_family/modules/home_map/home_map_module.dart';
import 'package:safe_lopes_family/modules/registration/registration_module.dart';
import 'package:safe_lopes_family/src/services/firebase/firebase_authentication_service/firebase_authentication_service.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.singleton((i) => FirebaseAuthenticationService()),
        Bind.lazySingleton((i) => AuthCubit(i())),
        Bind.lazySingleton((i) => AppCubit()),
        Bind.lazySingleton((i) => ForgotPasswordCubit(i())),

      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, params) => const AppWidget()),
        ModuleRoute('/home-map', module: HomeMapModule()),
        ModuleRoute('/auth', module: AuthModule()),
        ModuleRoute('/registration', module: RegistrationModule()),
        ModuleRoute('/circles', module: CirclesModule())
      ];
}
