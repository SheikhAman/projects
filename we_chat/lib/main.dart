import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:we_chat/auth/auth_service.dart';
import 'package:we_chat/page/chat_room_page.dart';
import 'package:we_chat/page/launcher_page.dart';
import 'package:we_chat/page/login_page.dart';
import 'package:we_chat/page/user_list_page.dart';
import 'package:we_chat/page/user_profile.dart';
import 'package:we_chat/providers/chat_room_provider.dart';
import 'package:we_chat/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ChatRoomProvider())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// mixin korlam WidgetsBindingObserver diye widget life cycel dhorar jonno
// implement korlam WidgetsBindingObserver ke
class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
// initState e StateFulWidget er lifeCycle observe korar jonno observer set korbo
  @override
  void initState() {
    // this bolte  MyAPPState ke bujache je kina WidgetsBindingObserver ke implement koreche
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (AuthService.user != null) {
      Provider.of<UserProvider>(context, listen: false)
          .updateProfile(AuthService.user!.uid, {'available': true});
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

// app amake janabe app background ba foreground e ache seta janate didChangeAppLifecycleState override korte hobe
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // AppLifecycleState hoche akta enum jar 4ta value ache(resumed,inactive,paused,detached)
    // TODO: implement didChangeAppLifecycleState

    // user app  theke ber hoye gese mane AppLifecycleState.paused
    if (state == AppLifecycleState.paused) {
      if (AuthService.user != null) {
        Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'available': false});
      }
    } else if (state == AppLifecycleState.resumed) {
      if (AuthService.user != null) {
        Provider.of<UserProvider>(context, listen: false)
            .updateProfile(AuthService.user!.uid, {'available': true});
      }
    }

    super.didChangeAppLifecycleState(state);
  }

// Observer add korar por observer remove o korte hoi na hole memory leak hote pare tai dispose korlam
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WE CHAT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (context) => LauncherPage(),
        LoginPage.routeName: (context) => LoginPage(),
        UserProfilePage.routeName: (context) => UserProfilePage(),
        ChatRoomPage.routeName: (context) => ChatRoomPage(),
        UserListPage.routeName: (context) => UserListPage()
      },
    );
  }
}
