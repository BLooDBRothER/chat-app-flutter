import 'package:chat_app_firebase/models/group_model.dart';
import 'package:chat_app_firebase/models/user_profile_model.dart';
import 'package:chat_app_firebase/providers/user_provider.dart';
import 'package:chat_app_firebase/service/group/group_request.dart';
import 'package:chat_app_firebase/widgets/groups/group_request_list_item.dart';
import 'package:chat_app_firebase/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupRequests extends ConsumerStatefulWidget {
  const GroupRequests({super.key});

  @override
  ConsumerState<GroupRequests> createState() => _GroupRequests();
}

class _GroupRequests extends ConsumerState<GroupRequests> {
  List<GroupRequestModel> groupRequests = [];
  bool isLoading = false;
  Map<String, bool> loadingGroups = {};

  late UserProfile user;

  Future<void> _fetchGroupRequests({bool triggerLoading = true}) async {
    if(triggerLoading) {
      setState(() {
        isLoading = true;
      });
    }
    user = await ref.read(userProfileProvider).getUser();
    final groups = await fetchGroupRequests(user.uid);

    setState(() {
      groupRequests = groups;
      isLoading = false;
    });
  }

  Future<void> _respondRequest(bool isAccepted, GroupRequestModel group) async {
    setState(() {
      loadingGroups[group.id] = true;
    });

    isAccepted ?
    await acceptGroup(group.id, user.uid, user.userToken!) :
    await rejectGroup(group.id, user.uid);

    await _fetchGroupRequests(triggerLoading: false);
  }

  Widget renderWidget() {
    if (isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Loader(
                size: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Fetching Your Invites...",
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          )
        ],
      );
    } else if (groupRequests.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You Don't have any requests!",
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          )
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: groupRequests.length,
      itemBuilder: (_, index) =>
          (GroupRequestListItem(
            groupData: groupRequests[index],
            isLoading: loadingGroups.containsKey(groupRequests[index].id),
            respondActions: _respondRequest,
          )),
      separatorBuilder: (_, index) => (const SizedBox(
        height: 8,
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchGroupRequests();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return renderWidget();
  }
}
