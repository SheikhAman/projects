import 'dart:io';

import 'package:blood_bank_project/Models/blood_bank.dart';
import 'package:blood_bank_project/auth_prefs.dart';
import 'package:blood_bank_project/pages/about_us_page.dart';
import 'package:blood_bank_project/pages/donor_details_page.dart';
import 'package:blood_bank_project/pages/donor_profile.dart';
import 'package:blood_bank_project/providers/blood_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'login_page.dart';

// import 'login_page.dart';

class BloodBankList extends StatefulWidget {
  static const String routeName = ' /blood_bank_list';

  const BloodBankList({Key? key}) : super(key: key);

  @override
  State<BloodBankList> createState() => _BloodBankListState();
}

class _BloodBankListState extends State<BloodBankList> {
  int selectedIndex = 0;

  final controller = TextEditingController();

  String? popValue;

  // void didChangeDependencies() {

  //   newBloodList = Provider.of<BloodBankProvider>(context).bloodBankList;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff52006A),
      appBar: AppBar(
        backgroundColor: Color(0xffDA0037),
        title: Consumer<BloodBankProvider>(
            builder: (context, provider, _) =>
                Text(selectedIndex == 0 ? 'BloodBank List' : 'Favorite Donor')),
        actions: [
          PopupMenuButton(
              color: Colors.grey,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: PopupMenuButton(
                        child: Text(
                          'Blood Groups',
                          style: TextStyle(color: Colors.blue),
                        ),
                        tooltip: 'Blood Groups',
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('A+');
                              },
                              child: Text('A+'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('A-');
                              },
                              child: Text('A-'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('AB+');
                              },
                              child: Text('AB+'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('AB-');
                              },
                              child: Text('AB-'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('B+');
                              },
                              child: Text('B+'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('B-');
                              },
                              child: Text('B-'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('O+');
                              },
                              child: Text('O+'),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              onPressed: () {
                                SearchByBlood('O-');
                              },
                              child: Text('O-'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: Consumer<BloodBankProvider>(
          builder: (context, provider, _) => BottomNavigationBar(
              currentIndex: selectedIndex,
              backgroundColor: Color(0xff99154E),
              selectedItemColor: Colors.white,
              onTap: (value) {
                selectedIndex = value;

                provider.loadContact(selectedIndex);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'All'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'Favorite'),
              ]),
        ),
      ),
      body: Column(
        children: [
          // Container(
          //   margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
          //   child: TextField(
          //     controller: controller,
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(Icons.search),
          //       hintText: 'area,blood group,etc',
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(20),
          //         borderSide: BorderSide(color: Colors.blue),
          //       ),
          //       suffixIcon: PopupMenuButton(
          //         itemBuilder: ((context) => [
          //               PopupMenuItem(
          //                 child: PopupMenuItem(
          //                   child: TextButton(
          //                     onPressed: () {
          //                       popValue = 'bloodGroup';
          //                     },
          //                     child: Text('Blood Group'),
          //                   ),
          //                 ),
          //               )
          //             ]),
          //       ),
          //     ),
          //     onChanged: (value) {
          //       callSearchMethod(value);
          //     },
          //     // onChanged:
          //     //     Provider.of<BloodBankProvider>(context,listen: false).getAllSearchItem,
          //   ),
          // ),
          Consumer<BloodBankProvider>(
            builder: (context, provider, _) => Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final bloodBank = provider.bloodBankList[index];

                    return OpenContainer(
                      transitionDuration: Duration(milliseconds: 3000),
                      openBuilder: (context, _) => DonorDetailsPage(),
                      closedBuilder: (context, _) => ExpansionPanelList.radio(
                        children: [
                          ExpansionPanelRadio(
                              backgroundColor: Colors.purple.shade200,
                              // backgroundColor: Color(0xff52006A),
                              value: bloodBank.id!,
                              headerBuilder: (context, isExpanded) => ListTile(
                                    textColor: Colors.white,
                                    title: Text(bloodBank.name),
                                    subtitle: Text(bloodBank.city),
                                    trailing: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Group: ${bloodBank.bloodGroup}"),
                                        Text("Donated: ${bloodBank.lbd}"),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, DonorDetailsPage.routeName,
                                          arguments: bloodBank.id);
                                    },
                                  ),
                              body: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        provider.getCall(bloodBank.number);
                                      },
                                      icon: Icon(Icons.call)),
                                  IconButton(
                                    onPressed: () {
                                      provider.getSms(bloodBank.number);
                                    },
                                    icon: Icon(Icons.message),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      provider.getLocation(bloodBank.city);
                                    },
                                    icon: Icon(Icons.location_on),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final value = bloodBank.favorite ? 0 : 1;
                                      provider.updateFavorite(
                                          bloodBank.id!, value, index);
                                    },
                                    icon: Icon(
                                      bloodBank.favorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: bloodBank.favorite
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  )
                                ],
                              ))
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height: 1,
                      indent: 6,
                      endIndent: 6,
                      color: Colors.grey.shade600,
                    );
                  },
                  itemCount: provider.bloodBankList.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SearchByBlood(value) {
    // final text = controller.text;
    Provider.of<BloodBankProvider>(context, listen: false)
        .getAllSearchItem(value);
  }

  popUpMenuMethod(value) {
    if (popValue == 'bloodGroup') {
      SearchByBlood(value);
    }
  }

  // buildHeader(BuildContext context) =>
  //     Consumer<BloodBankProvider>(builder: (context, provider, child) {
  //       int newIndex = provider.newDonorInfo.length == 2 ? 1 : 0;
  //       final newBloodInfo = provider.newDonorInfo[newIndex];
  //       return Container(
  //           width: double.infinity,
  //           color: Color(0xff898AA6),
  //           padding: EdgeInsets.only(
  //             top: MediaQuery.of(context).size.height * .06,
  //             bottom: 24,
  //           ),
  //           child: ListView(
  //             children: [

  //                 CircleAvatar(
  //                       radius: 60,
  //                       child: ClipRRect(
  //                         borderRadius: BorderRadius.all(Radius.circular(75)),
  //                         child: Image.file(
  //                           File(newBloodInfo.image!),
  //                           width: 120,
  //                           height: 120,
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                     ),
  //               SizedBox(
  //                 height: 12,
  //               ),
  //               Text(
  //                 newBloodInfo.name,
  //                 style: TextStyle(color: Colors.white, fontSize: 28),
  //               ),
  //               Text(
  //                 newBloodInfo.city,
  //                 style: TextStyle(color: Colors.white, fontSize: 16),
  //               ),
  //             ],
  //           ));

  // : Material(
  //     color: Color(0xff898AA6),
  //     child: Container(
  //       width: double.infinity,
  //       padding: EdgeInsets.only(
  //         top: MediaQuery.of(context).size.height * 0.09,
  //         bottom: 24,
  //       ),
  //       child: Column(
  //         children: [
  //           CircleAvatar(
  //             radius: 60,
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.all(Radius.circular(75)),
  //               child: Image.asset(
  //                 'images/pc.jpg',
  //                 width: 120,
  //                 height: 120,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 12,
  //           ),
  //           Text(
  //             'Test UserName',
  //             style: TextStyle(color: Colors.white, fontSize: 28),
  //           ),
  //           Text(
  //             'Test city',
  //             style: TextStyle(color: Colors.white, fontSize: 16),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // });

  buildMenuItems(BuildContext context) => Consumer<BloodBankProvider>(
        builder: (context, provider, child) => Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .07,
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: const Text('Donors'),
                onTap: () {
                  provider.loadContact(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorites'),
                onTap: () {
                  provider.loadContact(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('New Donor'),
                onTap: () {
                  getLoginStatus().then((value) {
                    if (value) {
                      Navigator.pushNamed(context, DonorProfile.routeName);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, LoginPage.routeName,
                          arguments: 'Donor Login');
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.pushNamed(context, AboutUsPage.routeName);
                },
              ),
              Divider(
                indent: 5,
                endIndent: 5,
                thickness: 0.4,
                height: 5,
                color: Colors.grey,
              ),
              ListTile(
                leading: const Icon(Icons.app_registration),
                title: const Text('Register Yourself'),
                onTap: () {
                  setLogicStatus(false).then((value) {
                    Navigator.pushReplacementNamed(context, LoginPage.routeName,
                        arguments: 'Donor Login');
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admin'),
                onTap: () {
                  setLogicStatus(false).then((value) {
                    Navigator.pushReplacementNamed(context, LoginPage.routeName,
                        arguments: 'Admin Login');
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log out'),
                onTap: () {
                  setLogicStatus(false).then((value) {
                    Navigator.pushNamed(context, LoginPage.routeName,
                        arguments: 'Donor Login');
                  });
                },
              ),
            ],
          ),
        ),
      );
}
