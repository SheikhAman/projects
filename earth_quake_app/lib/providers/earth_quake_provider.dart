import 'dart:convert';

import 'package:api_first_practice/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EarthQuakeProvider extends ChangeNotifier{

  ResponseModel? responseModel;
  String startTime = '', endTime = '';
  int minMagnitude = 4;


  bool get hasDataLoaded => responseModel != null;

  void queryParameter(String sTime, String eTime, int mm){
    startTime = sTime;
    endTime = eTime;
    minMagnitude = mm;
  }


  void getEarthQuakeData() async {
    final uri = Uri.parse('https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$startTime&endtime=$endTime&minmagnitude=$minMagnitude&orderby=time&orderby=magnitude');
    try {
      final response = await get(uri);
      final map = jsonDecode(response.body);
      if(response.statusCode == 200){
        responseModel = ResponseModel.fromJson(map);
        print(responseModel!.features!.length);
        notifyListeners();
      }
      else {
        print('Bad request');
      }
    }catch(error){
      rethrow;
    }

  }

}