import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreenProvider extends ChangeNotifier {
  int chatScreenActiveIndex = 0;
  var chatScreensTitle = {
    0: "Your Projects",
    1: "Project Requests"
  };

  void switchChatScreen(int index) {
    chatScreenActiveIndex = index;
    notifyListeners();
  }
}

final chatScreenProvider = ChangeNotifierProvider<ChatScreenProvider>((ref) => ChatScreenProvider());