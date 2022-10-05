import 'package:blood_bank_project/custom_widgets/custom_card.dart';
import 'package:blood_bank_project/pages/blood_list.dart';
import 'package:blood_bank_project/pages/donor_list_update_page.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  static const String routeName = '/admin_panel';
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Admin Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCard(
              text: 'View Donor',
              ontap: () {
                Navigator.pushNamed(context, DonorListUpdate.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
