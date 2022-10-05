import 'package:blood_bank_project/Models/blood_bank.dart';
import 'package:blood_bank_project/pages/admin_panel_page.dart';
import 'package:blood_bank_project/pages/blood_list.dart';
import 'package:blood_bank_project/pages/donor_details_page.dart';
import 'package:blood_bank_project/pages/donor_reg_page.dart';

import 'package:blood_bank_project/providers/blood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_prefs.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final numberController = TextEditingController();
  final passwordController = TextEditingController();

  bool isObscure = false;

  final _formKey = GlobalKey<FormState>();

  String? loginName;

  @override
  void didChangeDependencies() {
    loginName = ModalRoute.of(context)!.settings.arguments as String;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  BloodBankModel? bloodBankModel;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                ),
                Center(
                  child: Text(
                    loginName!,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: numberController,
                  decoration: InputDecoration(
                    labelText: 'Enter Phone Number',
                    prefixIcon: Icon(Icons.call),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Number can't be empty";
                    } else if (value.length > 11) {
                      return 'Number must be in 11 characters';
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Password',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: isObscure,
                  keyboardType: TextInputType.visiblePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password can\'t be empty';
                    }
                    // else if (value.length > 7) {

                    //   return 'Password must be at least 8 characters';
                    // }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (loginName == 'Admin Login')
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.7),
                    child: TextButton(
                      onPressed: () {
                        setLogicStatus(true).then((value) {
                          if(passwordController.text == '123456' && numberController.text == "01515631065" ){
                            Navigator.pushReplacementNamed(
                                context, AdminPanel.routeName);
                          }else{
                            showInputDialogue();
                          }

                        });
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (loginName == 'Donor Login')
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Provider.of<BloodBankProvider>(context,
                                      listen: false)
                                  .checkDonorNumberPassword(
                                      numberController.text,
                                      passwordController.text)
                                  .then((value) {
                                if (value) {
                                  setLogicStatus(value).then((value) {
                                    print('checkNumpass $value');
                                    Navigator.pushReplacementNamed(
                                        context, BloodBankList.routeName);
                                  });
                                }
                              });
                            }

                            // donor login
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Forgot Password',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, RegistrationPage.routeName);
                          },
                          child: Text(
                            'Register Yourself',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showInputDialogue() {
    showDialog(context: context,
        builder: (context) {
       return  AlertDialog(
         title: Text('You entered wrong number or password'),

         actions: [
           TextButton(
               onPressed: (){
                Navigator.of(context).pop();
       },
               child: Text('Try again'),
           )
         ],
       );

        },
    );
  }
}
