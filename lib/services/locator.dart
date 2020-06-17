import 'package:get_it/get_it.dart';
import 'package:plannusandroidversion/services/notificationservice.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NotificationService());
}