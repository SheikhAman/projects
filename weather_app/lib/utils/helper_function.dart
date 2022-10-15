import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getFormattedDateTime(num dt, String pattern) {
  return DateFormat(pattern)
      .format(DateTime.fromMillisecondsSinceEpoch(dt.toInt() * 1000));
}

String getFormattedDate(num date, String? pattern) {
  return DateFormat.yMMMd()
      .format(DateTime.fromMillisecondsSinceEpoch(date.toInt() * 1000));
}

String getFormattedTime(num date, String? pattern) {
  return DateFormat.jm()
      .format(DateTime.fromMillisecondsSinceEpoch(date.toInt() * 1000));
}

void showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
  ));
}

Future<bool> isConnectedToInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
