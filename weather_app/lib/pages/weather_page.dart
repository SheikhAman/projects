import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/forecast_response_model.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_function.dart';
import 'package:weather_app/utils/location_utils.dart';
import 'package:weather_app/utils/txt_styles..dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherPage extends StatefulWidget {
  static const String routeName = '/';
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherProvider provider;
  bool isFirst = true;
  String loadMsg = 'Please wait...';
  var subscription;

  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setState(() {
          loadMsg = 'Please wait...';
          _getData();
        });
      } else {}
      // Got a new connectivity status!
    });

    super.initState();
  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    subscription.cancel();
  }

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      provider = Provider.of<WeatherProvider>(context);
      isConnectedToInternet().then((value) async {
        if (value) {
          _getData();
        } else {
          setState(() {
            loadMsg =
                'No internet connection detected. Please turn on your wifi or mobile data';
          });
        }
      });

      isFirst = false;
    }
    super.didChangeDependencies();
  }

  getDefaultCityData() async {
    try {
      Map<String, double> map = await provider.getPrefDefaultCityLatLng();
      provider.setNewLocation(map['lat']!, map['lng']!);
      print(map);
      provider.setDefaultCity(await provider.getPrefDefaultCityValue());
      provider.setTempUnit(await provider.getPreferenceTempUnitValue());
      provider.getWeatherData();
    } catch (error) {
      rethrow;
    }
  }

  _getData() async {
    try {
      print('fdfget ${await provider.getPrefDefaultCityLatLng()}');
      if (await provider.getPrefDefaultCityValue()) {
        getDefaultCityData();
      } else {
        final position = await determinePosition();
        provider.setNewLocation(position.latitude, position.longitude);
        provider.setTempUnit(await provider.getPreferenceTempUnitValue());
        provider.getWeatherData();
      }
    } catch (error) {
      final position = await Geolocator.getCurrentPosition();
      provider.setNewLocation(position.latitude, position.longitude);
      provider.setTempUnit(await provider.getPreferenceTempUnitValue());
      provider.getWeatherData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff081b25),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Weather'),
        actions: [
          IconButton(
            disabledColor: Colors.grey,
            onPressed: provider.defaultCity
                // provider.defaultCityGet
                ? null
                : () {
                    _getData();
                  },
            icon: const Icon(Icons.my_location),
          ),
          IconButton(
            onPressed: () async {
              final result = await showSearch(
                  context: context, delegate: _CitySearchDelegate());
              if (result != null && result.isNotEmpty) {
                print(result);
                // geolocator use kore city re lat lng e convert kora hoise ei method diye
                provider.convertAddressToLatLng(result);
              }
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, SettingsPage.routeName),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: provider.hasDataLoaded
            ? ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  _currentWeatherSection(),
                  _forecastWeatherSection(),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  loadMsg,
                  style: txtNormal16,
                ),
              ),
      ),
    );
  }

  Widget _currentWeatherSection() {
    final response = provider.currentResponseModel;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          getFormattedDateTime(response!.dt!, 'MMM dd, yyyy'),
          style: txtAddress24,
        ),
        Text(
          '${response.name},${response.sys!.country}',
          style: txtAddress24,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                '$iconPrefix${response.weather![0].icon}$iconSuffix',
                height: 75,
                width: 75,
                fit: BoxFit.cover,
              ),
              Text(
                '${response.main!.temp!.round()}$degree${provider.unitSymbol}',
                style: txtTempBig80,
              ),
            ],
          ),
        ),
        Wrap(
          children: [
            Text(
              'feels like ${response.main!.feelsLike!.round()}$degree${provider.unitSymbol}',
              style: txtNormal16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '${response.weather![0].main}, ${response.weather![0].description},',
              style: txtNormal16,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          children: [
            Text(
              'Humidity ${response.main!.humidity}%',
              style: txtNormal16White54,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Pressure ${response.main!.pressure}hPa',
              style: txtNormal16White54,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Visibility ${response.visibility}meter',
              style: txtNormal16White54,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Wind ${response.wind!.speed}m/s',
              style: txtNormal16White54,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Degree ${response.wind!.deg}$degree',
              style: txtNormal16White54,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          children: [
            Text(
              'Sunrise ${getFormattedDateTime(response.sys!.sunrise!, 'hh:mm a')}',
              style: txtNormal16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Sunset ${getFormattedDateTime(response.sys!.sunset!, 'hh:mm a')}',
              style: txtNormal16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _forecastWeatherSection() {
    final response = provider.forecastResponseModel;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Forecast Weather",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1,
              wordSpacing: 1),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: response!.list!.length,
            itemBuilder: (context, index) {
              final model = response.list![index];

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      getFormattedDate(
                        model.dt!,
                        "pattern",
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      getFormattedTime(model.dt!, "pattern"),
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Image.network(
                      "$iconPrefix${model.weather![0].icon}$iconSuffix",
                      color: Colors.amber,
                      height: 80,
                    ),
                    Text(
                        "${model.main!.temp!.round()}$degree${provider.unitSymbol}",
                        style: TextStyle(color: Colors.white)),
                    Text("${model.weather![0].description}",
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    Text(
                        "${model.main!.tempMin!.round()}$degree${provider.unitSymbol} / ${model.main!.tempMax!.round()}$degree${provider.unitSymbol}",
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
                margin: const EdgeInsets.all(5),
                height: 220,
                width: 135,
                decoration: BoxDecoration(
                    color: const Color(0xff152c39),
                    borderRadius: BorderRadius.circular(15)),
              );
            },
          ),
        )
      ],
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return ListTile(
      leading: const Icon(Icons.search),
      title: Text(query),
      onTap: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final filteredList = query.isEmpty
        ? cities
        : cities
            .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(filteredList[index]),
        onTap: () {
          query = filteredList[index];
          close(context, query);
        },
      ),
    );
  }
}
