import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat/auth/auth_service.dart';
import 'package:we_chat/page/chat_room_page.dart';
import 'package:we_chat/page/launcher_page.dart';
import 'package:we_chat/page/login_page.dart';
import 'package:we_chat/page/user_list_page.dart';
import 'package:we_chat/page/user_profile.dart';
import 'package:we_chat/providers/user_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.blue.shade700,
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProfilePage.routeName);
            },
            leading: const Icon(Icons.person),
            title: const Text('MY PROFILE'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, UserListPage.routeName);
            },
            leading: const Icon(Icons.group),
            title: const Text('USERS LIST'),
          ),
          ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, ChatRoomPage.routeName);
            },
            leading: Icon(Icons.chat),
            title: const Text('CHAT ROOM'),
          ),
          ListTile(
            onTap: () async {
              await Provider.of<UserProvider>(context, listen: false)
                  .updateProfile(AuthService.user!.uid, {'available': false});
              await AuthService.logout();
              await Navigator.pushReplacementNamed(
                  context, LauncherPage.routeName);
            },
            leading: Icon(Icons.logout),
            title: const Text('LOGOUT'),
          )
        ],
      ),
    );
  }
}
