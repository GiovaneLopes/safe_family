import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/circles/submodules/new_circle/new_circle.dart';
import 'package:safe_lopes_family/modules/circles/submodules/new_circle/new_circle_cubit.dart';

class NewCircleModule extends Module {
  @override
  List<Bind<Object>> get binds =>
      [Bind.lazySingleton((i) => NewCircleCubit(i()))];
  @override
  List<ModularRoute> get routes =>
      [ChildRoute('/', child: (context, args) => const NewCircle())];
}
