import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/auth/auth_service.dart';

import '../db/dbhelper.dart';
import '../models/message_model.dart';

class ChatRoomProvider extends ChangeNotifier {
  List<MessageModel> msgList = [];

  Future<void> addMsg(String msg) {
    final messageModel = MessageModel(
      msgId: DateTime.now().millisecondsSinceEpoch,
      userUid: AuthService.user!.uid,
      userName: AuthService.user!.displayName,
      userImage: AuthService.user!.photoURL,
      email: AuthService.user!.email!,
      msg: msg,
      timestamp: Timestamp.fromDate(DateTime.now()),
    );
    return DBHelper.addMsg(messageModel);
  }

  getAllChatRoomMessages() {
    // future hole then use kori r stream hole listen
    // snapshot hoche onk gulo doc er snapshot
    // amake  portekta doc loop chaliye ber korte hobe abong portekta doc r vitore je map ache seta fromMap method bebohar kore MessageModel er object e convert korte hobe then setake list e convert kore msgList e assign korte hobe

    DBHelper.getAllChatRoomMessages().listen((snapshot) {
      msgList = List.generate(snapshot.docs.length,
          (index) => MessageModel.fromMap(snapshot.docs[index].data()));
      // notun snapshot asle notifyListener korbe ui update hobe
      notifyListeners();
    });
  }
}
