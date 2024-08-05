import 'package:chat_app_firebase/models/group_model.dart';
import 'package:chat_app_firebase/widgets/loader.dart';
import 'package:flutter/material.dart';

class GroupRequestListItem extends StatelessWidget {
  const GroupRequestListItem({
    super.key,
    required this.groupData,
    required this.isLoading,
    required this.respondActions
  });

  final GroupRequestModel groupData;
  final bool isLoading;
  final Function(bool isAccepted, GroupRequestModel group) respondActions;


  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: groupData.profileImage == null
                    ? null
                    : NetworkImage(groupData.profileImage!),
                radius: 28,
                child: const Icon(Icons.groups),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupData.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          groupData.description,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
              )),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: isLoading ?
                const Loader(size: 20,) :
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          respondActions(true, groupData);
                        },
                        icon: const Icon(Icons.done),
                        style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.primary
                        ),
                    ),
                    // const SizedBox(height: 4),
                    IconButton(
                        onPressed: () {
                          respondActions(false, groupData);
                        },
                        icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error
                      ),
                    ),
                  ],

              )
              )
            ],
          ),
        ));
  }
}
