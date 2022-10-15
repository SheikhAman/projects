import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/provider/weather_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff152c39),
            title: const Text('Settings'),
          ),
          body: Consumer<WeatherProvider>(
            builder: (context, provider, _) => ListView(
              padding: const EdgeInsets.all(8),
              shrinkWrap: true,
              children: [
                SwitchListTile(
                    title: const Text('Show temperature in Fahrenheit'),
                    subtitle: const Text('Default is Celsius'),
                    value: provider.isFahrenheit,
                    onChanged: (value) async {
                      provider.setTempUnit(value);
                      await provider.setPreferenceTempUnitValue(value);
                      provider.getWeatherData();
                    }),
                SwitchListTile(
                    title: const Text('Set current city as default'),
                    value: provider.defaultCity,
                    // provider.defaultCityGet,
                    onChanged: (value) async {
                      provider.setDefaultCity(value);
                      await provider.setPrefDefaultCityValue(value);
                      await provider.setPrefDefaultCityLatLng(
                          provider.latitude, provider.longitude);
                      // print('fdfdf   ${provider.longitude}');
                      // print('fdfddf   ${provider.latitude}');
                      provider.getWeatherData();
                    })
              ],
            ),
          )),
    );
  }
}
