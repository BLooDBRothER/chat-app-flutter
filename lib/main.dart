import 'package:chat_app_firebase/screens/authentication.dart';
import 'package:chat_app_firebase/theme/theme_config.dart';
import 'package:flutter/material.dart';

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Color.fromARGB(255, 41, 125, 5),
);

void main() {
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
      home: const AuthenticationScreen()
    );
  }
}
