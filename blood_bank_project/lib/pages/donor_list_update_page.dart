import 'package:blood_bank_project/pages/donor_reg_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_prefs.dart';
import '../providers/blood_provider.dart';
import 'donor_details_page.dart';
import 'login_page.dart';

class DonorListUpdate extends StatefulWidget {
  static const String routeName = ' /donor_list_update';

  const DonorListUpdate({Key? key}) : super(key: key);

  @override
  State<DonorListUpdate> createState() => _DonorListUpdateState();
}

class _DonorListUpdateState extends State<DonorListUpdate> {
  int selectedIndex = 0;

  String? popValue;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Consumer<BloodBankProvider>(
              builder: (context, provider, _) => Text(
                  selectedIndex == 0 ? 'Donor List Update' : 'Favorite Donor')),
          actions: [
            PopupMenuButton(
                color: Colors.grey,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: PopupMenuButton<PopupMenuItem>(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              'Blood Groups',
                              style: TextStyle(color: Colors.blue),
                            ),
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
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            setLogicStatus(false).then((value) =>
                                Navigator.pushReplacementNamed(
                                    context, LoginPage.routeName,
                                    arguments: 'Donor Login'));
                          },
                          child: Text('Donor'),
                        ),
                      ),
                      PopupMenuItem(
                        child: TextButton(
                          onPressed: () {
                            setLogicStatus(false).then((value) =>
                                Navigator.pushReplacementNamed(
                                    context, LoginPage.routeName,
                                    arguments: 'Admin Login'));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text('Log Out'),
                          ),
                        ),
                      ),
                    ]),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, RegistrationPage.routeName);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          child: Consumer<BloodBankProvider>(
            builder: (context, provider, _) => BottomNavigationBar(
                currentIndex: selectedIndex,
                backgroundColor: Colors.purple,
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
        body: Consumer<BloodBankProvider>(
          builder: (context, provider, _) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                final bloodBank = provider.bloodBankList[index];
                return Dismissible(
                  key: ValueKey(bloodBank.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: _showConfirmationDialog,
                  onDismissed: (direction) =>
                      provider.deleteDonor(bloodBank.id!),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ExpansionPanelList.radio(
                    children: [
                      ExpansionPanelRadio(
                          value: bloodBank.id!,
                          headerBuilder: (context, isExpanded) => ListTile(
                                onLongPress: () {},
                                title: Text(bloodBank.name),
                                subtitle: Text(bloodBank.city),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ));
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Donor'),
        content: const Text('Are you sure to delete this Donor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
