import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerSingleton(NavigationService());
}