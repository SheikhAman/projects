import 'package:blood_bank_project/db/db_helper.dart';
import 'package:flutter/material.dart';
import '../Models/blood_bank.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankProvider extends ChangeNotifier {
  List<BloodBankModel> bloodBankList = [];
  List<BloodBankModel> newDonorInfo = [];

// query by blood group
  getAllSearchItem(String bloodGroup) {
    DBHelper.getAllSearchItem(bloodGroup).then((value) {
      bloodBankList = value;
      print(value);
      notifyListeners();
    });
  }

// getting all donor list
  getAllBloodList() {
    DBHelper.getAllBloodBankInfo().then((value) {
      bloodBankList = value;
      notifyListeners();
    });
  }

// getting last object for drawer

  getLastDonorInfo() {
    DBHelper.getLastBloodBankInfo().then((value) {
      newDonorInfo.add(value);
      notifyListeners();
    });
  }

// get all favorites
  getAllFavoriteInfo() {
    DBHelper.getAllFavorite().then((value) {
      bloodBankList = value;
      notifyListeners();
    });
  }

  // loadContact from bottomNav
  loadContact(int index) {
    switch (index) {
      case 0:
        getAllBloodList();
        break;
      case 1:
        getAllFavoriteInfo();
    }
  }

// update favorite

  updateFavorite(int id, int value, int index) =>
      DBHelper.updateFavorite(id, value).then((_) {
        bloodBankList[index].favorite = !bloodBankList[index].favorite;
        bloodBankList.sort(
          (a, b) => a.name.compareTo(b.name),
        );
        notifyListeners();
      });

// delete Donor from Donor List

  deleteDonor(int id) async {
    final rowId = await DBHelper.deleteDonor(id);
    if (rowId > 0) {
      bloodBankList.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }

  // load donar info

  loadBlood(int index) {
    switch (index) {
      case 0:
        getAllBloodList();
        break;
      case 1:
        getAllFavoriteInfo();
    }
  }

// adding new donor
  Future<bool> addNewBlood(BloodBankModel bloodBankModel) async {
    //print('ubyyvy'+bloodBankModel.toString());
    final rowId = await DBHelper.insertBloodBank(bloodBankModel);
    if (rowId > 0) {
      bloodBankModel.id = rowId;
      bloodBankList.add(bloodBankModel);
      print('Bloof Bank List ${bloodBankList.length}');
      bloodBankList.sort((a, b) => a.name.compareTo(b.name));

      // i am using it for donor info in drawer
      // newDonorInfo.add(bloodBankModel);

      notifyListeners();
      return true;
    }

    return false;
  }

// get Bloodbank object using id, we are using method from db

  Future<BloodBankModel> getBloodBankId(int id) =>
      DBHelper.getBloodBankById(id);

  Future<bool> checkDonorNumberPassword(String number, String password) =>
      DBHelper.checkDonorNumberPassword(number, password);

  getCall(String number) async {
    final Uri _url = Uri.parse('tel:$number');

    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  getSms(String number) async {
    final Uri _url = Uri.parse('sms:$number');

    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  getLocation(String location) async {
    final Uri _url = Uri.parse('geo:0,0?q=$location');

    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
