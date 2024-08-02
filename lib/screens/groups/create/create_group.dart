import 'dart:developer';
import 'dart:io';

import 'package:chat_app_firebase/models/user_profile_model.dart';
import 'package:chat_app_firebase/providers/user_provider.dart';
import 'package:chat_app_firebase/service/group/create_group.dart';
import 'package:chat_app_firebase/widgets/image_picker_actions.dart';
import 'package:chat_app_firebase/widgets/loader.dart';
import 'package:chat_app_firebase/widgets/user_list_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreen();
}

class _CreateGroupScreen extends ConsumerState<CreateGroupScreen> {
  UserProfile? searchedUser;
  List<UserProfile> _addedUser = [];
  FileImage? _pickedImage;
  File? _pickedImageFile;
  bool _isCreating = false;
  bool _isSearching = false;
  bool _isSameUser = false;

  final _searchTextController = TextEditingController();
  final _groupNameTextController = TextEditingController();
  final _groupDescriptionTextController = TextEditingController();

  void showSnackbarError(String error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<String?> _uploadGroupProfilePic(String uuid) async {
    if (_pickedImageFile == null) {
      return null;
    }

    return await uploadGroupProfilePic(uuid, _pickedImageFile!);
  }

  void _createGroup() async {
    if (_isCreating || _isSearching) {
      return;
    }

    if (_groupNameTextController.text == "") {
      showSnackbarError("Please provide Group Chat Name");
      return;
    }
    if(_groupDescriptionTextController.text == "") {
      showSnackbarError("Please provide Group Description");
      return;
    }
    setState(() {
      _isCreating = true;
    });

    var uuid = const Uuid().v4();

    String? fileUrl = await _uploadGroupProfilePic(uuid);
    final userProvider = ref.read(userProfileProvider);

    final groupData = {
      "name": _groupNameTextController.text,
      "description": _groupDescriptionTextController.text,
      "profileImage": fileUrl,
      "admin": [userProvider.userProfile!.uid],
      "users": [],
      "pendingRequest": _addedUser.map((user) => user.uid).toList(),
      "isNotificationTriggered": false,
      "createdAt": Timestamp.now(),
      "updatedAt": Timestamp.now()
    };

    await createGroup(uuid, groupData);

    setState(() {
      _isCreating = false;
    });

    if (!context.mounted) return;
    Navigator.pop(context); // No warnings now
  }

  void _addUser() {
    setState(() {
      _addedUser = [..._addedUser, searchedUser!];
      searchedUser = null;
    });
  }

  void _removeUser(UserProfile user) {
    setState(() {
      _addedUser.remove(user);
    });
  }

  void _searchUser() async {
    final userProvider = ref.read(userProfileProvider);
    if (_isCreating || _isSearching || !userProvider.isFetched) {
      return;
    }
    if (userProvider.userProfile!.username == _searchTextController.text ||
        _addedUser.any((user) => user.username == _searchTextController.text)) {
      setState(() {
        _isSameUser = true;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isSameUser = false;
    });

    try {
      final user = await searchUser(_searchTextController.text);
      setState(() {
        searchedUser = user;
      });
    }
    catch(e) {
      log("Error while searching user ${e.toString()}", name: "Groups", time: DateTime.timestamp());
    }
    finally {
      setState(() {
        _isSearching = false;
      });
    }

  }

  void _closeBottomSheet() {
    Navigator.pop(context);
  }

  void _setImage(XFile? pickedImage) async {
    if (pickedImage == null) {
      return;
    }

    _closeBottomSheet();

    _pickedImageFile = File(pickedImage.path);

    setState(() {
      _pickedImage = FileImage(_pickedImageFile!);
    });
    // await ref.read(userProfileProvider).uploadProfilePic(pickedImageFile);
  }

  void _pickImageFromGallery() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 250);
    _setImage(pickedImage);
  }

  void _captureFromCamera() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 250);
    _setImage(pickedImage);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _groupNameTextController.dispose();
    _groupDescriptionTextController.dispose();
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group Chat!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: InkWell(
                  child: CircleAvatar(
                    foregroundImage: _pickedImage,
                    radius: 32,
                    child: const Icon(Icons.person),
                  ),
                  onTap: () => {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext ctx) => Wrap(children: [
                              ImagePickerActions(
                                  pickFromGallery: _pickImageFromGallery,
                                  captureFromCamera: _captureFromCamera)
                            ]))
                  },
            )),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _groupNameTextController,
              decoration: const InputDecoration(
                label: Text("Group Name"),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please Enter Valid username address";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _groupDescriptionTextController,
              decoration: const InputDecoration(
                label: Text("Group Description"),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please Enter Description";
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _searchTextController,
                    decoration: InputDecoration(
                        label: const Text("Username"),
                        suffixIcon: IconButton(
                            // icon: const Icon(Icons.search), onPressed: searchUser),
                            icon: const Icon(Icons.search),
                            onPressed: _searchUser),
                        errorText: _isSameUser ? "User Already Exisit" : null),
                    textCapitalization: TextCapitalization.none,
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                    onPressed: _createGroup,
                    child: _isCreating ? const Loader() : const Text("Create"))
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Searched User",
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    searchedUser == null
                        ? _isSearching
                            ? const Loader()
                            : const Text("No user Found")
                        : Row(
                            children: [
                              UserListItem(user: searchedUser!),
                              const Spacer(),
                              IconButton(
                                  onPressed: _addUser,
                                  icon: const Icon(Icons.person_add))
                            ],
                          )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Users Added",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 8),
                      if (_addedUser.isEmpty) ...[const Text("No user Added")],
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: _addedUser
                                .map((user) => Row(
                                      children: [
                                        UserListItem(user: user),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () =>
                                                {_removeUser(user)},
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            icon: const Icon(Icons.delete))
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
