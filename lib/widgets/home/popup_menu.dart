import 'package:chat_app_firebase/data/menu.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:chat_app_firebase/service/user/firebase_user_api.dart';
import 'package:flutter/material.dart';

PopupMenuButton homePopupMenu () {
  return (
      PopupMenuButton<MenuItems>(
        icon: const Icon(Icons.more_vert),
        position: PopupMenuPosition.under,
        onSelected: (MenuItems item) {
          switch (item) {
            case MenuItems.signout:
              handleSignOut();
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
  );
}