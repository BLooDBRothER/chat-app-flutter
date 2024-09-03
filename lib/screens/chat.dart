import 'package:chat_app_firebase/data/menu.dart';
import 'package:chat_app_firebase/models/screen_arguments.dart';
import 'package:chat_app_firebase/screens/groups/create/create_group.dart';
import 'package:chat_app_firebase/screens/groups/request/group_requests.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:chat_app_firebase/widgets/home/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  static const routeName = "/";
  static const screenTitle = "Your Groups";

  void _handleSignout(WidgetRef ref) {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(screenTitle),
        actions: [
          PopupMenuButton<MenuItems>(
            icon: const Icon(Icons.more_vert),
            position: PopupMenuPosition.under,
            onSelected: (MenuItems item) {
              switch (item) {
                case MenuItems.signout:
                  _handleSignout(ref);
                  break;
                case MenuItems.settings:
                  locator<NavigationService>().pushTo("/settings");
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
              const PopupMenuItem(
                value: MenuItems.settings,
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Settings")
                  ],
                ),
              ),
              const PopupMenuItem(
                value: MenuItems.signout,
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Signout")
                  ],
                ),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<NavigationService>().pushTo(CreateGroupScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(0, () =>
      {
        locator<NavigationService>().pushAndReplaceTo(
            GroupRequests.routeName, arguments: const ScreenArguments(navigateWithoutAnimation: true))
      }),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Text("Chat Home"),
      )
    );
  }
}
