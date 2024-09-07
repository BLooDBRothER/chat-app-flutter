import 'package:chat_app_firebase/models/screen_arguments.dart';
import 'package:chat_app_firebase/screens/groups/request/group_requests.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:chat_app_firebase/widgets/home/bottom_navigation_bar.dart';
import 'package:chat_app_firebase/widgets/home/create_group_float_button.dart';
import 'package:chat_app_firebase/widgets/home/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  static const routeName = "/";
  static const _screenTitle = "Your Groups";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_screenTitle),
        actions: [homePopupMenu()],
      ),
      floatingActionButton: createGroupFloatButton(),
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
