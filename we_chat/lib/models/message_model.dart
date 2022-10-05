import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? userUid, image, userName, userImage;
  int? msgId;
  String msg, email;
  Timestamp timestamp;

  MessageModel(
      {this.msgId,
      this.userUid,
      this.image,
      this.userName,
      this.userImage,
      required this.email,
      required this.msg,
      required this.timestamp});

  Map<String, dynamic> toMap(MessageModel messageModel) {
    return <String, dynamic>{
      'msgId': msgId,
      'userUid': userUid,
      'image': image,
      'userName': userName,
      'userImage': userImage,
      'email': email,
      'msg': msg,
      'timestamp': timestamp
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      msg: map['msg'],
      timestamp: map['timestamp'],
      msgId: map['msgId'],
      image: map['image'],
      email: map['email'],
      userName: map['userName'],
      userImage: map['userImage'],
      userUid: map['userUid'],
    );
  }
}
