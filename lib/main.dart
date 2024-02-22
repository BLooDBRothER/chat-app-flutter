import 'package:chat_app_firebase/firebase_options.dart';
import 'package:chat_app_firebase/screens/authentication.dart';
import 'package:chat_app_firebase/screens/chat.dart';
import 'package:chat_app_firebase/screens/splash_screen.dart';
import 'package:chat_app_firebase/theme/theme_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyChatApp());
}

class MyChatApp extends StatelessWidget {
  const MyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      darkTheme: MyAppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if(snapshot.hasData) {
            return const ChatScreen();
          }

          return const AuthenticationScreen();
        },
      )
    );
  }
}
