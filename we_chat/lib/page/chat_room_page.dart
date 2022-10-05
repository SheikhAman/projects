import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat/models/message_model.dart';
import 'package:we_chat/providers/chat_room_provider.dart';
import 'package:we_chat/widgets/main_drawer.dart';
import 'package:we_chat/widgets/message_item.dart';

class ChatRoomPage extends StatefulWidget {
  static const String routeName = '/room';
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final msgController = TextEditingController();
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      Provider.of<ChatRoomProvider>(context, listen: false)
          .getAllChatRoomMessages();
      isFirst = false;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    msgController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      drawer: const MainDrawer(),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Chat Room'),
      ),
      body: Consumer<ChatRoomProvider>(
        builder: (context, provider, _) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: provider.msgList.length,
                itemBuilder: (context, index) {
                  final msg = provider.msgList[index];
                  return MessageItem(
                    messageModel: msg,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintText: 'Type your message here',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // text jodi empty hoi tahole method theke return korbe
                      if (msgController.text.isEmpty) return;
                      provider.addMsg(msgController.text);
                      msgController.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
