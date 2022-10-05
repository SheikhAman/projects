import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:we_chat/models/user_models.dart';
import 'package:we_chat/auth/auth_service.dart';
import 'package:we_chat/page/launcher_page.dart';
import 'package:we_chat/page/login_page.dart';
import 'package:we_chat/providers/user_provider.dart';

import '../widgets/main_drawer.dart';

class UserProfilePage extends StatefulWidget {
  static const String routeName = '/user_profile';
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProiflePageState();
}

class _UserProiflePageState extends State<UserProfilePage> {
  final txtController = TextEditingController();
  @override
  void dispose() {
    txtController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<UserProvider>(context, listen: false)
                  .updateProfile(AuthService.user!.uid, {'available': false});
              await AuthService.logout();
            await  Navigator.pushReplacementNamed(context, LauncherPage.routeName);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) =>
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: provider.getUserByUid(AuthService.user!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userModel = UserModel.fromMap(snapshot.data!.data()!);

                return ListView(
                  children: [
                    Center(
                      child: userModel.image == null
                          ? Image.asset(
                              'images/person.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              userModel.image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    TextButton.icon(
                      onPressed: _updateImage,
                      icon: const Icon(Icons.camera),
                      label: const Text('Change Image'),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 1,
                    ),
                    ListTile(
                      title: Text(userModel.name ?? 'No Display Name'),
                      trailing: IconButton(
                          onPressed: () {
                            showInputDialog('Display Name', userModel.name,
                                (value) async {
                              await provider.updateProfile(
                                  AuthService.user!.uid, {'name': value});
                              await AuthService.updateDisplayName(value);
                            });
                          },
                          icon: const Icon(Icons.edit)),
                    ),
                    ListTile(
                      title: Text(userModel.mobile ?? 'No Mobile Number'),
                      trailing: IconButton(
                          onPressed: () {
                            showInputDialog('Mobile Number', userModel.mobile,
                                (value) {
                              provider.updateProfile(
                                  AuthService.user!.uid, {'mobile': value});
                            });
                          },
                          icon: const Icon(Icons.edit)),
                    ),
                    ListTile(
                      title: Text(userModel.email ?? 'No Email Address'),
                      trailing: IconButton(
                          onPressed: () {
                            showInputDialog('Email Address', userModel.email,
                                (value) {
                              provider.updateProfile(
                                  AuthService.user!.uid, {'email': value});
                            });
                          },
                          icon: const Icon(Icons.edit)),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                return const Text('Failed to fetch data');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  void _updateImage() async {
    // imageQuality 0-100 r modhe jekono value dewa jai 0 hoche lowest 100 hoche highest
    final xFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 75);
    if (xFile != null) {
      try {
        if (!mounted) return;
        final downloadUrl =
            await Provider.of<UserProvider>(context, listen: false)
                .updateImage(xFile);
        await Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'image': downloadUrl});
        await AuthService.updateDisplayImage(downloadUrl);
      } catch (e) {
        rethrow;
      }
    }
  }

  showInputDialog(String title, String? value, Function(String) onSaved) {
    txtController.text = value ?? '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: txtController,
                  decoration: InputDecoration(
                    hintText: 'Enter $title',
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL')),
                TextButton(
                    onPressed: () {
                      onSaved(txtController.text);
                      Navigator.pop(context);
                    },
                    child: const Text('UPDATE'))
              ],
            ));
  }
}
