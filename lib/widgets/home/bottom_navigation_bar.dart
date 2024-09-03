import 'package:flutter/material.dart';

NavigationBar bottomNavigationBarWidget(int selectedIndex, Function() navigate) {
  return NavigationBar(
    selectedIndex: selectedIndex,
    onDestinationSelected: (index) {
      if (index == selectedIndex) {
        return;
      }
      navigate();
    },
    destinations: const [
      NavigationDestination(icon: Icon(Icons.group), label: "Groups"),
      NavigationDestination(icon: Icon(Icons.group_add), label: "Request"),
    ],
  );
}