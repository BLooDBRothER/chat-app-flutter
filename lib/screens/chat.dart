import 'package:chat_app_firebase/data/menu.dart';
import 'package:chat_app_firebase/providers/chat_screen_provider.dart';
import 'package:chat_app_firebase/providers/user_provider.dart';
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

  void _handleSignout(WidgetRef ref) {
    ref.read(userProfileProvider).clearUsers();
    FirebaseAuth.instance.signOut();
  }

  void showCreateGroupModal(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const CreateGroupScreen()));
  }

  Widget _activeScreen(int index) {
    switch(index) {
      case 0:
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Text("Chat Home"),
        );
      case 1:
        return const GroupRequests();
      default:
        return const Text("Your Groups");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userProfileProvider).getUser();
    final selectedIndex = ref.watch(chatScreenProvider).chatScreenActiveIndex;
    final screenTitle = ref.read(chatScreenProvider).chatScreensTitle[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle!),
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
          showCreateGroupModal(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar.bottomNavigationBarWidget(selectedIndex, ref.read(chatScreenProvider).switchChatScreen),
      body: _activeScreen(selectedIndex)
    );
  }
}
