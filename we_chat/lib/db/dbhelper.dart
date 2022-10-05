import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:we_chat/models/message_model.dart';
import 'package:we_chat/models/user_models.dart';

class DBHelper {
  static const String collectionUser = 'Users';
  static const String collectionRoomMessage = 'ChatRoomMessages';
  // firebase database er object return korbe
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addUser(UserModel userModel) {
    final doc = _db.collection(collectionUser).doc(userModel.uid);
    return doc.set(userModel.toMap());
  }

// msg database e add hoche
  static Future<void> addMsg(MessageModel messageModel) {
    // msgId hobe int timestamp tai poroborti sort korte subidha hobe
    return _db
        .collection(collectionRoomMessage)
        .doc()
        .set(messageModel.toMap(messageModel));
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(
          String uid) =>
      _db.collection(collectionUser).doc(uid).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUidFuture(
          String uid) =>
      _db.collection(collectionUser).doc(uid).get();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChatRoomMessages() =>
      _db
          .collection(collectionRoomMessage)
          .orderBy('msgId', descending: true)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllRemainingUsers(
          String uid) =>
      _db
          .collection(collectionUser)
          .where('uid', isNotEqualTo: uid)
          .snapshots();

  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUser).doc(uid).update(map);
  }
}
