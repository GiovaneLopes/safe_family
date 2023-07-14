import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/listen_circle_location_usecase_imp.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/sign_out_usecase_imp.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/stream_device_battery_usecase_imp.dart';
import 'package:safe_lopes_family/modules/home_map/domain/usecases/stream_gps_usecase_imp.dart';
import 'package:safe_lopes_family/modules/home_map/external/home_datasource_imp.dart';
import 'package:safe_lopes_family/modules/home_map/home_map_cubit.dart';
import 'package:safe_lopes_family/modules/home_map/home_map_page.dart';
import 'package:safe_lopes_family/modules/home_map/infra/listen_circle_location_repository_imp.dart';
import 'package:safe_lopes_family/modules/home_map/infra/sign_out_repository_imp.dart';
import 'package:safe_lopes_family/modules/home_map/infra/stream_device_battery_repository_imp.dart';
import 'package:safe_lopes_family/modules/home_map/infra/stream_gps_repository_imp.dart';
import 'package:safe_lopes_family/src/modules/circles/domain/usecases/get_circle_usecase_imp.dart';
import 'package:safe_lopes_family/src/modules/circles/external/circle_datasource_imp.dart';
import 'package:safe_lopes_family/src/modules/circles/infra/get_circle_repository_imp.dart';
import 'package:safe_lopes_family/src/modules/user/domain/usecases/get_user_usecase_imp.dart';
import 'package:safe_lopes_family/src/modules/user/external/user_datasource_imp.dart';
import 'package:safe_lopes_family/src/modules/user/infra/get_user_respoitory_imp.dart';

class HomeMapModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.lazySingleton((i) => HomeDatasourceImp()),
        Bind.lazySingleton((i) => ListenCircleLocationUsecaseImp(i())),
        Bind.lazySingleton((i) => ListenCircleLocationRepositoryImp(i())),
        Bind.lazySingleton((i) => StreamGpsUsecaseImp(i())),
        Bind.lazySingleton((i) => StreamGpsRepositoryImp(i())),
        Bind.lazySingleton((i) => GetCircleUsecaseImp(i())),
        Bind.lazySingleton((i) => GetCircleRepositoryImp(i())),
        Bind.lazySingleton((i) => SignOutUsecaseImp(i())),
        Bind.lazySingleton((i) => SignOutRepositoryImp(i())),
        Bind.lazySingleton((i) => HomeMapCubit(i(), i(), i(), i(), i(), i())),
        Bind.lazySingleton((i) => CircleDatasourceImp()),
        Bind.lazySingleton((i) => GetUserUsecaseImp(i())),
        Bind.lazySingleton((i) => GetUserRepositoryImp(i())),
        Bind.lazySingleton((i) => UserDatasourceImp()),
        Bind.lazySingleton((i) => StreamDeviceBatteryUsecaseImp(i())),
        Bind.lazySingleton((i) => StreamDeviceBatteryRepositoryImp(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => const HomeMapPage()),
      ];
}
