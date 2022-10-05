import 'dart:io';

import 'package:blood_bank_project/Models/blood_bank.dart';
import 'package:blood_bank_project/pages/blood_list.dart';
import 'package:blood_bank_project/providers/blood_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../auth_prefs.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/login_page';
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String groupValue = 'Male';

  String dropdownValue = "A+";

  String? dob;

  String? lbd;

  ImageSource imageSource = ImageSource.camera;

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Bank Reg'),
        actions: [
          TextButton(
            onPressed: saveInfo,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Enter Name',
                  fillColor: Colors.white54,
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name can\'t be empty';
                  } else if (value.length > 20) {
                    return 'Name must be is 20 characters';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Number',
                  fillColor: Colors.white54,
                  prefixIcon: Icon(Icons.call),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  } else if (value.length > 20) {
                    return 'number must be is 20 characters';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  fillColor: Colors.white54,
                  prefixIcon: Icon(Icons.password),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password can\'t be empty';
                  } else if (value.length < 8) {
                    return 'Password can\'t be less than 8 characters';
                  } else {
                    return null;
                  }
                },
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Chose Your Blood Group'),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      elevation: 8,
                      style: TextStyle(color: Colors.red),
                      underline: Container(
                        height: 2,
                        color: Colors.redAccent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'A+',
                        'A-',
                        'AB+',
                        'AB-',
                        'B+',
                        'B-',
                        'O+',
                        'O-',
                      ].map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: cityController,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  labelText: 'Enter Your Location',
                  fillColor: Colors.white54,
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: datePicker,
                      child: Text('Select Date Of Birth'),
                    ),
                    Text(dob != null ? dob! : 'No Selected Date'),
                  ],
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: lbdPicker,
                      child: Text('Select Last Blood Donation Date'),
                    ),
                    Text(lbd != null ? lbd! : 'No Selected Date'),
                  ],
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Select Gender'),
                    Radio<String>(
                        value: 'Male',
                        groupValue: groupValue,
                        activeColor: Colors.red,
                        hoverColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        }),
                    Text('Male'),
                    Radio<String>(
                        value: 'Female',
                        groupValue: groupValue,
                        activeColor: Colors.red,
                        hoverColor: Colors.blueAccent,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        }),
                    Text('Female'),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    imagePath != null
                        ? Image.file(
                            File(imagePath!),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'images/pc.jpg',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              imageSource = ImageSource.camera;
                              pickImage();
                            },
                            child: Text('Camera')),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              imageSource = ImageSource.gallery;
                              pickImage();
                            },
                            child: Text('Gallery')),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    final selectedImage =
        await ImagePicker().pickImage(source: imageSource); // local variable
    if (selectedImage != null) {
      setState(() {
        imagePath = selectedImage.path;
      });
    }
  }

  void datePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        dob = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void lbdPicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        lbd = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void saveInfo() async {
    if (_formKey.currentState!.validate()) {
      final bloodBank = BloodBankModel(
          name: nameController.text,
          number: numberController.text,
          password: passwordController.text,
          bloodGroup: dropdownValue,
          city: cityController.text,
          dob: dob!,
          lbd: lbd!,
          gender: groupValue,
          image: imagePath);

      final status =
          await Provider.of<BloodBankProvider>(context, listen: false)
              .addNewBlood(bloodBank);

      final lastBloodInfo =
          Provider.of<BloodBankProvider>(context, listen: false)
              .newDonorInfo
              .add(bloodBank);
      if (status) {
        setLogicStatus(status).then((value) {
          if (value) {
            Navigator.pushReplacementNamed(context, BloodBankList.routeName);
          } else {
            throw 'dghfjds';
          }
        });
      }
    }
  }
}
