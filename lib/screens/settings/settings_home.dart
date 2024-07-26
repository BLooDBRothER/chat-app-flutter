import 'package:chat_app_firebase/screens/settings/profile.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static const routeName = "/settings";

  void _navigateProfileScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext ctx) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
              InkWell(
                onTap: () {
                  _navigateProfileScreen(context);
                },
                borderRadius: BorderRadius.circular(8),
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 8,),
                      const Text("Profile"),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),)
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
