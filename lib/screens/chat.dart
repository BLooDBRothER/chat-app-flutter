import 'package:chat_app_firebase/data/menu.dart';
import 'package:chat_app_firebase/screens/settings/settings_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _handleSignout () {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Chat"),
        actions: [
          PopupMenuButton<MenuItems>(
            icon: const Icon(Icons.more_vert),
            position: PopupMenuPosition.under,
            onSelected: (MenuItems item) {
              switch(item) {
                case MenuItems.signout:
                  _handleSignout();
                  break;
                case MenuItems.settings:
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext ctx) => const SettingScreen()));
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
              const PopupMenuItem(
                value: MenuItems.settings,
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8,),
                    Text("Settings")
                  ],
                ),
              ),
              const PopupMenuItem(
                value: MenuItems.signout,
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8,),
                    Text("Signout")
                  ],
                ),
              )
            ],
          )
        ],
      ), 
      body: Text("demo"),
    );
  }
}
