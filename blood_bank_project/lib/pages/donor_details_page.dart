import 'dart:io';

import 'package:blood_bank_project/Models/blood_bank.dart';
import 'package:blood_bank_project/providers/blood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/blood_bank.dart';
import '../pages/blood_list.dart';

class DonorDetailsPage extends StatefulWidget {
  static const String routeName = '/donor_details';
  const DonorDetailsPage({Key? key}) : super(key: key);

  @override
  State<DonorDetailsPage> createState() => _DonorDetailsPageState();
}

class _DonorDetailsPageState extends State<DonorDetailsPage> {
  int? id;

  @override
  void didChangeDependencies() {
    id = ModalRoute.of(context)!.settings.arguments as int;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text('Donor Details'),
      ),
      body: Consumer<BloodBankProvider>(
        builder: (context, provider, _) => FutureBuilder<BloodBankModel>(
            //row return korse id dhore
            future: provider.getBloodBankId(id!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final bloodInfo = snapshot.data;

                print(bloodInfo?.image);
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: ListView(
                      children: [
                        bloodInfo?.image != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 75,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(75)),
                                    child: Image.file(
                                      File(bloodInfo!.image!),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 75,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(75)),
                                    child: Image.asset(
                                      'images/pc.jpg',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Name: ${bloodInfo!.name}',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Phone No: ${bloodInfo.number}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Blood Group: ${bloodInfo.bloodGroup}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Location: ${bloodInfo.city}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Gender: ${bloodInfo.gender}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Date Of Birth: ${bloodInfo.dob}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "Last Donation Date: ${bloodInfo.lbd}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
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
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Go Back',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text('Failed to fetch data');
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}

// ListView(
// children: [
// CircleAvatar(
// radius: 30,
// child: provider.getBloodBankId(bl)bloodBankModel!.image != null ?  Image.file(File(bloodBankModel!.image!),height: 100,width: 100,fit: BoxFit.cover,) : Image.asset('images/pc.jpg',
// height: 100,width: 100,fit: BoxFit.cover,
// ),
// ),
// Text('Name: ${bloodBankModel!.name}'),
// Text('Number: ${bloodBankModel!.number}'),
// Text('Number: ${bloodBankModel!.gender}'),
// Text('Donor Blood Group: ${bloodBankModel!.bloodGroup}'),
// Text('Donor Last Blood donation date: ${bloodBankModel!.lbd}'),
// Text('Donor Location: ${bloodBankModel!.city}'),
// Text('Donor Last Blood donation date: ${bloodBankModel!.lbd}')
