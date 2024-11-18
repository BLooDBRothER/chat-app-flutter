import 'package:chat_app_firebase/models/screen_arguments.dart';
import 'package:chat_app_firebase/screens/groups/create/create_group.dart';
import 'package:chat_app_firebase/screens/groups/request/group_requests.dart';
import 'package:chat_app_firebase/service/notification/firebase_message_api.dart';
import 'package:chat_app_firebase/service/notification/notification_api.dart';
import 'package:chat_app_firebase/firebase_options.dart';
import 'package:chat_app_firebase/screens/authentication.dart';
import 'package:chat_app_firebase/screens/chat.dart';
import 'package:chat_app_firebase/screens/settings/settings_home.dart';
import 'package:chat_app_firebase/screens/splash_screen.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:chat_app_firebase/service/user/firebase_user_api.dart';
import 'package:chat_app_firebase/theme/theme_config.dart';
import 'package:chat_app_firebase/widgets/no_animation_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocator();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyChatApp()
    )
  );
}

class MyChatApp extends ConsumerStatefulWidget {
  const MyChatApp({super.key});

  @override
  ConsumerState<MyChatApp> createState() => _MyChatApp();
}

class _MyChatApp extends ConsumerState<MyChatApp> {

  @override
  void initState() {
    super.initState();
    initUserAuthStateChange(ref);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FlutterChat',
      darkTheme: MyAppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      initialRoute: SplashScreen.routeName,
      onGenerateRoute: (settings) {

        final args = settings.arguments == null
            ? const ScreenArguments(navigateWithoutAnimation: false)
            : settings.arguments as ScreenArguments;

        if(settings.name == SplashScreen.routeName) {
          return MaterialPageRoute(builder: (context) => const SplashScreen());
        }

        if(settings.name == AuthenticationScreen.routeName) {
          return  MaterialPageRoute(builder: (context) => const AuthenticationScreen());
        }

        if(settings.name == ChatScreen.routeName) {
          return args.navigateWithoutAnimation
            ? NoAnimationMaterialPageRoute(builder: (context) => const ChatScreen())
            : MaterialPageRoute(builder: (context) => const ChatScreen());
        }

        if (settings.name == CreateGroupScreen.routeName) {
          return MaterialPageRoute(builder: (context) => const CreateGroupScreen());
        }

        if (settings.name == GroupRequests.routeName) {
          return args.navigateWithoutAnimation
           ? NoAnimationMaterialPageRoute(builder: (context) => const GroupRequests())
           : MaterialPageRoute(builder: (context) => const GroupRequests());
        }

        if(settings.name == SettingScreen.routeName) {
          return  MaterialPageRoute(builder: (context) => const SettingScreen());
        }

        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
