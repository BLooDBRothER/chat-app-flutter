import 'package:flutter/material.dart';

class CustomBottomNavigationBar {
  static _navigate(int index, Function(int) navigate) {
    navigate(index);
  }

  static bottomNavigationBarWidget(int selectedIndex, Function(int) navigate) => (
    NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if(index == selectedIndex) {
          return;
        }
        _navigate(index, navigate);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.group), label: "Groups"),
        NavigationDestination(icon: Icon(Icons.group_add), label: "Request"),
      ],
    )
  );
}