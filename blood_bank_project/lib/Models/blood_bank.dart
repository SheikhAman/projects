import 'package:blood_bank_project/pages/blood_list.dart';

const String tableBloodBank = 'blood_table';
const String tableBloodBankColId = 'id';
const String tableBloodBankColName = 'name';
const String tableBloodBankColNumber = 'number';
const String tableBloodBankColPassword = 'password';
const String tableBloodBankColBloodGroup = 'bloodGroup';
const String tableBloodBankColCity = 'city';
const String tableBloodBankColDob = 'dob';
const String tableBloodBankColGender = 'gender';
const String tableBloodBankColImage = 'image';
const String tableBloodBankColFavorite = 'favorite';
const String tableBloodBankColLbd = 'lbd';

class BloodBankModel {
  int? id;
  String name;
  String number;
  String bloodGroup;
  String city;
  String password;
  String? dob;
  String? gender;
  String? image;
  bool favorite;
  String lbd;
  BloodBankModel({
    this.id,
    this.image,
    this.favorite = false,
    this.dob,
    this.gender,
    required this.city,
    required this.name,
    required this.number,
    required this.bloodGroup,
    required this.lbd,
    required this.password,
  });

  @override
  String toString() {
    return 'BloodBankModel{id: $id, name: $name, number: $number, bloodGroup: $bloodGroup, city: $city, password: $password, dob: $dob, gender: $gender, image: $image, favorite: $favorite, lbd: $lbd}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      tableBloodBankColName: name,
      tableBloodBankColNumber: number,
      tableBloodBankColPassword: password,
      tableBloodBankColBloodGroup: bloodGroup,
      tableBloodBankColCity: city,
      tableBloodBankColDob: dob,
      tableBloodBankColGender: gender,
      tableBloodBankColImage: image,
      tableBloodBankColLbd: lbd,
      tableBloodBankColFavorite: favorite ? 1 : 0,
    };
    if (map[id] != null) {
      map[tableBloodBankColId] = id;
    }
    return map;
  }

  factory BloodBankModel.fromMap(Map<String, dynamic> map) {
    return BloodBankModel(
      id: map[tableBloodBankColId],
      name: map[tableBloodBankColName],
      number: map[tableBloodBankColNumber],
      password: map[tableBloodBankColPassword],
      bloodGroup: map[tableBloodBankColBloodGroup],
      city: map[tableBloodBankColCity],
      dob: map[tableBloodBankColDob],
      gender: map[tableBloodBankColGender],
      image: map[tableBloodBankColImage],
      favorite: map[tableBloodBankColFavorite] == 1 ? true : false,
      lbd: map[tableBloodBankColLbd],
    );
  }
}
