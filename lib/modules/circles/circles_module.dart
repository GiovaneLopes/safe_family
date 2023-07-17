import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/circles/circles_cubit.dart';
import 'package:safe_lopes_family/modules/circles/circles_page.dart';
import 'package:safe_lopes_family/modules/circles/submodules/new_circle/new_circle_module.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/get_circle_usecase_imp.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/set_circle_usecase_imp.dart';
import 'package:safe_lopes_family/src/modules/circles/external/circle_datasource_imp.dart';
import 'package:safe_lopes_family/src/modules/circles/infra/get_circle_repository_imp.dart';
import 'package:safe_lopes_family/src/modules/circles/infra/set_circle_repository_imp.dart';

class CirclesModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => CirclesCubit(i(), i())),
        Bind.lazySingleton((i) => GetCircleUsecaseImp(i())),
        Bind.lazySingleton((i) => GetCircleRepositoryImp(i())),
        Bind.lazySingleton((i) => CircleDatasourceImp()),
        Bind.lazySingleton((i) => SetCircleUsecaseImp(i())),
        Bind.lazySingleton((i) => SetCircleRepositoryImp(i())),
      ];
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const CirclesPage()),
        ModuleRoute('/new-circle', module: NewCircleModule()),
      ];
}
