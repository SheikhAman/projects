import 'dart:io';

import 'package:blood_bank_project/Models/blood_bank.dart';
import 'package:blood_bank_project/auth_prefs.dart';
import 'package:blood_bank_project/pages/blood_list.dart';
import 'package:blood_bank_project/pages/donor_reg_page.dart';
import 'package:blood_bank_project/providers/blood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorProfile extends StatefulWidget {
  static const String routeName = '/donor_profile';
  DonorProfile({Key? key}) : super(key: key);

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('New Donor Profile'),
      ),
      body: Consumer<BloodBankProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                    itemCount: provider.newDonorInfo.length == 2 ? 1 : 1,
                    itemBuilder: (context, index) {
                      print(index);
                      int newIndex = provider.newDonorInfo.length == 2 ? 1 : 0;
                      final newBloodInfo = provider.newDonorInfo[newIndex];
                      return Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            newBloodInfo.image != null
                                ? CircleAvatar(
                                    radius: 75,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(75)),
                                      child: Image.file(
                                        File(newBloodInfo.image!),
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 70,
                                    backgroundImage: AssetImage(
                                      'images/pc.jpg',
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Name: ${newBloodInfo.name}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Phone No: ${newBloodInfo.number}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Blood Group: ${newBloodInfo.bloodGroup}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Location: ${newBloodInfo.city}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Gender: ${newBloodInfo.gender}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Date Of Birth: ${newBloodInfo.dob}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Last Donation Date: ${newBloodInfo.lbd}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.31,
                                        vertical: size.height * 0.02),
                                    primary: Color(0xffc95823),
                                    onPrimary: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, BloodBankList.routeName);
                                  },
                                  child: Text(
                                    'Go Back',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    })),
          ),
        );
      }),
    );
  }
}
