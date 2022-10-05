import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat/models/user_models.dart';
import 'package:we_chat/auth/auth_service.dart';
import 'package:we_chat/page/launcher_page.dart';
import 'package:we_chat/page/user_profile.dart';
import 'package:we_chat/providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool isLogin = true, isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email Address',
                    filled: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: isObscureText,
                controller: passController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    filled: true,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                        icon: Icon(isObscureText
                            ? Icons.visibility_off
                            : Icons.visibility))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  isLogin = true;
                  authenticate();
                },
                child: Text('Login'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('New User?'),
                  TextButton(
                    onPressed: () {
                      isLogin = false;
                      authenticate();
                    },
                    child: Text('Register Here'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Forget Password?'),
                  TextButton(
                    onPressed: () {},
                    child: Text('Click Here'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                errMsg,
                style: TextStyle(color: Theme.of(context).errorColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  void authenticate() async {
    if (formKey.currentState!.validate()) {
      try {
        bool status;
        if (isLogin) {
          status = await AuthService.login(
              emailController.text, passController.text);
        } else {
          status = await AuthService.register(
              emailController.text, passController.text);
          await AuthService.sendEmailVerification();
          final userModel = UserModel(
            uid: AuthService.user!.uid,
            email: AuthService.user!.email,
            // baki info nilamna  bakigulo pore update korbo
          );
          if (!mounted) return;
          await Provider.of<UserProvider>(context, listen: false)
              .addUser(userModel);
        }
        if (status) {
          // widget widget tree te thakle pushreplace korbe
          if (!mounted) return;

          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message.toString();
        });
      }
    }
  }
}
