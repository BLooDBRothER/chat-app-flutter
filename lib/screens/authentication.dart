import 'package:chat_app_firebase/widgets/authentication/credential_form.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Project Chat"),), 
      body: const CredentialForm()
    );
  }
}
