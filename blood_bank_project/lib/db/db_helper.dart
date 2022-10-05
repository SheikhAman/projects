import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

import '../Models/blood_bank.dart';

class DBHelper {
  static const String createTableBloodBank = '''
  create table $tableBloodBank(
  $tableBloodBankColId integer primary key,
  $tableBloodBankColName text,
  $tableBloodBankColNumber text,
  $tableBloodBankColPassword text,
  $tableBloodBankColBloodGroup text,
  $tableBloodBankColCity text,
  $tableBloodBankColDob text,
  $tableBloodBankColLbd text,
  $tableBloodBankColGender text,
  $tableBloodBankColImage text,
  $tableBloodBankColFavorite integer
)

''';

// database open and table created
  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'bloodbank.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(createTableBloodBank);
      },
    );
  }

  // insert method
  static Future<int> insertBloodBank(BloodBankModel bloodBankModel) async {
    final db = await open(); // database open method  called

    print('MODEL :' + bloodBankModel.toString());
    return db.insert(tableBloodBank, bloodBankModel.toMap());
  }

// getting List of map and converting as List of BloodBankModel objects
  static Future<List<BloodBankModel>> getAllBloodBankInfo() async {
    final db = await open();

    final mapList = await db.query(tableBloodBank);

    return List.generate(
        mapList.length, (index) => BloodBankModel.fromMap(mapList[index]));
  }

// last bloodbank info for drawer,
  static Future<BloodBankModel> getLastBloodBankInfo() async {
    final db = await open();

    final mapList = await db.query(tableBloodBank);

    final lastBloodInfo = BloodBankModel.fromMap(mapList.last);

    return lastBloodInfo;
  }

  // update favorites

  static Future<int> updateFavorites(int id, int value) async {
    final db = await open();
    return db.update(tableBloodBank, {tableBloodBankColFavorite: value},
        where: '$tableBloodBankColId = ?', whereArgs: [id]);
  }

// get All Favorites

  static Future<List<BloodBankModel>> getAllFavorite() async {
    final db = await open();
    final mapList = await db.query(tableBloodBank,
        where: '$tableBloodBankColFavorite = ?',
        whereArgs: [1],
        orderBy: tableBloodBankColName);
    return List.generate(
        // akta akta kore map object e porinoto hobe
        mapList.length,
        (index) => BloodBankModel.fromMap(mapList[index]));
  }

  static Future<List<BloodBankModel>> getAllSearchItem(
      String bloodGroup) async {
    final db = await open();
    final mapList = await db.query(
      tableBloodBank,
      where: '$tableBloodBankColBloodGroup = ?',
      whereArgs: [bloodGroup],
    );

    return List.generate(
        mapList.length, (index) => BloodBankModel.fromMap(mapList[index]));
  }

  // update Favorites

  static Future<int> updateFavorite(int id, int value) async {
    final db = await open();
    return db.update(tableBloodBank, {tableBloodBankColFavorite: value},
        where: '$tableBloodBankColId = ?', whereArgs: [id]);
  }

  // get BloodBank object using id

  static Future<BloodBankModel> getBloodBankById(int id) async {
    final db = await open();
    final mapList = await db.query(tableBloodBank,
        where: '$tableBloodBankColId = ?', whereArgs: [id]);

    return BloodBankModel.fromMap(mapList.first);
  }

  // delete Donor from Donor List
  static Future<int> deleteDonor(int id) async {
    final db = await open();
    return db.delete(tableBloodBank,
        where: '$tableBloodBankColId = ?', whereArgs: [id]);
  }

  // donor number and password auth checked
  static Future<bool> checkDonorNumberPassword(
      String number, String password) async {
    final db = await open();
    final mapList = await db.query(tableBloodBank,
        where:
            '$tableBloodBankColNumber = ? and $tableBloodBankColPassword = ?',
        whereArgs: [number, password]);
    if (mapList.length > 0) {
      return true;
    }
    return false;
  }
}
