import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/current_response_model.dart';
import 'package:weather_app/models/forecast_response_model.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:geocoding/geocoding.dart' as Geo;
import 'package:weather_app/utils/helper_function.dart';

class WeatherProvider extends ChangeNotifier {
  CurrentResponseModel? currentResponseModel;
  ForecastResponseModel? forecastResponseModel;
  double latitude = 0.0, longitude = 0.0;
  String unit = 'metric';
  String unitSymbol = celsius;
  bool defaultCity = false;

  // bool get defaultCityGet => defaultCity;

  bool get hasDataLoaded =>
      currentResponseModel != null && forecastResponseModel != null;

  bool get isFahrenheit => unit == imperial;

  void setNewLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
  }

  void setTempUnit(bool tag) {
    unit = tag ? imperial : metric;
    unitSymbol = tag ? fahrenheit : celsius;
    notifyListeners();
  }

  void setDefaultCity(bool value) {
    defaultCity = value ? true : false;
    notifyListeners();
  }

  // shared pref methods
  Future<bool> setPreferenceTempUnitValue(bool tag) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setBool('unit', tag);
  }

  Future<bool> getPreferenceTempUnitValue() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('unit') ?? false;
  }

// shared  pref for default city

  Future<bool> setPrefDefaultCityValue(bool value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setBool('defaultCity', value);
  }

  Future<bool> getPrefDefaultCityValue() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('defaultCity') ?? false;
  }

  Future<void> setPrefDefaultCityLatLng(double lat, double lng) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setDouble('lat', latitude);
    await pref.setDouble('lng', longitude);
  }

  Future<Map<String, double>> getPrefDefaultCityLatLng() async {
    final pref = await SharedPreferences.getInstance();
    final lat = pref.getDouble('lat') ?? 0.0;
    final lng = pref.getDouble('lng') ?? 0.0;
    return {'lat': lat, 'lng': lng};
  }

  // Future<void> get

  getWeatherData() {
    _getCurrentData();
    _getForecastData();
  }

  void _getCurrentData() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$unit&appid=$weather_api_key');
    try {
      final response = await get(uri);
      final map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        currentResponseModel = CurrentResponseModel.fromJson(map);
        // print(currentResponseModel!.name);
        notifyListeners();
      } else {
        // print(map['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  void _getForecastData() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$unit&appid=$weather_api_key');
    try {
      final response = await get(uri);
      final map = jsonDecode(response.body);
      // print(map);
      if (response.statusCode == 200) {
        forecastResponseModel = ForecastResponseModel.fromJson(map);
        print(forecastResponseModel!.list!.length);
        notifyListeners();
      } else {
        // print(map['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

// geoLocator use kore city name diye lat long  ber korse
  void convertAddressToLatLng(String result) async {
    // city name jodi a,b,c hoi tai try catch dilam
    try {
      final locationList = await Geo.locationFromAddress(result);
      if (locationList.isNotEmpty) {
        // not empty hole porthom location ta ber korbo
        final location = locationList.first;
        setNewLocation(location.latitude, location.longitude);
        getWeatherData();
      } else {
        print('City not found');
      }
    } catch (error) {
      // easyloading o use korte partam
      // user vul city type korse othoba city valid kintu  lat long khuje pai nai
      print(error.toString());
    }
  }
}
