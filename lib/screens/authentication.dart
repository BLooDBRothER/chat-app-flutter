import 'package:chat_app_firebase/widgets/authentication/credential_form.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  static const routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Group Chat"),),
      body: const CredentialForm()
    );
  }
}
