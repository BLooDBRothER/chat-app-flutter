import 'package:chat_app_firebase/providers/user_provider.dart';
import 'package:chat_app_firebase/screens/authentication.dart';
import 'package:chat_app_firebase/screens/chat.dart';
import 'package:chat_app_firebase/service/locator.dart';
import 'package:chat_app_firebase/service/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void initUserAuthStateChange(WidgetRef ref) {
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if(user == null) {
      ref.read(userProfileProvider).clearUsers();
      locator<NavigationService>().pushAndReplaceTo(AuthenticationScreen.routeName);
    }
    else {
      onUserLoggedIn(ref);
    }
  });
}

Future<void> onUserLoggedIn(WidgetRef ref) async {

  await ref.read(userProfileProvider).fetchUserDetails();
  locator<NavigationService>().pushAndReplaceTo(ChatScreen.routeName);
}

void handleSignOut() {
  FirebaseAuth.instance.signOut();
}