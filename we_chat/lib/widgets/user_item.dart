import 'package:flutter/material.dart';
import 'package:we_chat/models/user_models.dart';

class UserItem extends StatelessWidget {
  final UserModel userModel;
  const UserItem({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          // backgroundImage: userModel.image == null
          //     ? AssetImage('images/person.png')
          //     : NetworkImage(userModel.image!) as ImageProvider,
          child: userModel.image == null
              ? Image.asset(
                  'images/person.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  userModel.image!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(userModel.name ?? userModel.email!),
      subtitle: Text(
        userModel.available ? 'Online' : 'Offline',
        style:
            TextStyle(color: userModel.available ? Colors.amber : Colors.grey),
      ),
    );
  }
}
