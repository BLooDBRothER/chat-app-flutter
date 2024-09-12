import 'package:chat_app_firebase/screens/groups/create/create_group.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:flutter/material.dart';

FloatingActionButton createGroupFloatButton() {
  return (FloatingActionButton(
    onPressed: () {
      locator<NavigationService>().pushTo(CreateGroupScreen.routeName);
    },
    child: const Icon(Icons.add),
  ));
}
