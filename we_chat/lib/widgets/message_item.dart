import 'package:flutter/material.dart';
import 'package:we_chat/auth/auth_service.dart';
import 'package:we_chat/models/message_model.dart';
import 'package:we_chat/utils/helper_functions.dart';

class MessageItem extends StatelessWidget {
  final MessageModel messageModel;
  const MessageItem({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: messageModel.userUid == AuthService.user!.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // CircleAvatar(
            //   child: messageModel.userImage != null
            //       ? Image.network(
            //           messageModel.userImage!,
            //           fit: BoxFit.cover,
            //           height: 100,
            //           width: 100,
            //         )
            //       : Image.asset(
            //           'images/person.png',
            //           fit: BoxFit.cover,
            //           height: 100,
            //           width: 100,
            //         ),
            // ),
            Text(
              messageModel.userName ?? messageModel.email,
              style: const TextStyle(color: Colors.blue, fontSize: 12),
            ),
            Text(
              getFormattedDate(messageModel.timestamp.toDate()),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              messageModel.msg,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
