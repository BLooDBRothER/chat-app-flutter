import 'package:chat_app_firebase/data/menu.dart';
import 'package:chat_app_firebase/providers/user_provider.dart';
import 'package:chat_app_firebase/widgets/home/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupRequests extends ConsumerStatefulWidget {
  const GroupRequests({super.key});

  @override
  ConsumerState<GroupRequests> createState() => _GroupRequests();
}

class _GroupRequests extends ConsumerState<GroupRequests> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: const Text("group request"),
    );
  }
}