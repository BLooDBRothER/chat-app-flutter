import 'package:chat_app_firebase/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserListItem extends StatelessWidget {
  const UserListItem({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          foregroundImage: user.profileUrl != null ? NetworkImage(user.profileUrl!) : null,
          radius: 16,
          child: const Icon(Icons.person),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          user.username,
          style: Theme.of(context).textTheme.titleMedium
        )
      ],
    );
  }
}
