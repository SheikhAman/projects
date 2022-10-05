import 'package:blood_bank_project/pages/about_us_page.dart';
import 'package:blood_bank_project/pages/admin_panel_page.dart';
import 'package:blood_bank_project/pages/blood_list.dart';
import 'package:blood_bank_project/pages/donor_details_page.dart';
import 'package:blood_bank_project/pages/donor_list_update_page.dart';
import 'package:blood_bank_project/pages/donor_profile.dart';
import 'package:blood_bank_project/pages/donor_reg_page.dart';
import 'package:blood_bank_project/pages/login_page.dart';
import 'package:blood_bank_project/providers/blood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) => BloodBankProvider()
          ..getAllBloodList()
          ..getLastDonorInfo()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: BloodBankList.routeName,
      routes: {
        BloodBankList.routeName: (context) => BloodBankList(),
        LoginPage.routeName: (context) => LoginPage(),
        RegistrationPage.routeName: (context) => RegistrationPage(),
        DonorDetailsPage.routeName: (context) => DonorDetailsPage(),
        AdminPanel.routeName: (context) => AdminPanel(),
        DonorListUpdate.routeName: (context) => DonorListUpdate(),
        DonorProfile.routeName: (context) => DonorProfile(),
        AboutUsPage.routeName: (context) => AboutUsPage()
      },
    );
  }
}
