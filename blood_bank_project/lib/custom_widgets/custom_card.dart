import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  String text;
  void Function() ontap;

  CustomCard({required this.text, required this.ontap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: ontap,
      child: Container(
        height: size.height * 0.2,
        width: size.width * 0.5,
        child: Card(
          shadowColor: Colors.blueGrey,
          margin: EdgeInsets.all(12),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
