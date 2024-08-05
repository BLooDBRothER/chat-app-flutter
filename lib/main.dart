import 'package:chat_app_firebase/service/notification/firebase_message_api.dart';
import 'package:chat_app_firebase/service/notification/notification_api.dart';
import 'package:chat_app_firebase/firebase_options.dart';
import 'package:chat_app_firebase/service/notification/notification_initializer.dart';
import 'package:chat_app_firebase/screens/authentication.dart';
import 'package:chat_app_firebase/screens/chat.dart';
import 'package:chat_app_firebase/screens/settings/settings_home.dart';
import 'package:chat_app_firebase/screens/splash_screen.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:chat_app_firebase/theme/theme_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setUpLocator();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessageApi().initNotification();
  await NotificationApi.init();

  runApp(
    const ProviderScope(
      child: MyChatApp()
    )
  );
}

class MyChatApp extends ConsumerWidget {
  const MyChatApp({super.key});

  StreamBuilder _buildScreen(String route, WidgetRef ref) {
    NotificationInitializer.ref = ref;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        FirebaseMessageApi.loadInitialMessage();

        if(snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if(snapshot.hasData) {
          switch(route) {
            case ChatScreen.routeName:
              return const ChatScreen();
            case SettingScreen.routeName:
              return const SettingScreen();
          }
        }
        return const AuthenticationScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'FlutterChat',
      darkTheme: MyAppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routes: {
        ChatScreen.routeName: (context) => _buildScreen(ChatScreen.routeName, ref),
        SettingScreen.routeName: (context) => _buildScreen(SettingScreen.routeName, ref)
      },
      initialRoute: ChatScreen.routeName,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
