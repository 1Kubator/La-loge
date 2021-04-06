import 'package:get_it/get_it.dart';
import 'package:la_loge/service/database_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DatabaseService());
}
