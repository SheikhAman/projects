import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat/auth/auth_service.dart';
import 'package:we_chat/page/login_page.dart';
import 'package:we_chat/page/user_list_page.dart';
import 'package:we_chat/page/user_profile.dart';

import '../providers/user_provider.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher';
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (AuthService.user == null) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      } else {
        Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'available': true});
        Navigator.pushReplacementNamed(context, UserListPage.routeName);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
