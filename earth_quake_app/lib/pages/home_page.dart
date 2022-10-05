import 'package:api_first_practice/providers/earth_quake_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/helper_function.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {



  String selectedDate = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);

      });
    }
  }

  String startDate = '2022-01-20', endDate = '2022-01-21';



  final List<String> items = [
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];
  String? selectedValue = '4';
  late EarthQuakeProvider earthQuakeProvider;

  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      earthQuakeProvider =
          Provider.of<EarthQuakeProvider>(context);
    }

    isFirst = false;
    super.didChangeDependencies();
  }

  _getData() async {
    try {
      earthQuakeProvider.queryParameter(startDate, endDate, int.parse(selectedValue!));
      earthQuakeProvider.getEarthQuakeData();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Earth Quake List'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                      setState((){
                        endDate = selectedDate;
                      });
                    },
                    child: Text('From'),
                  ),
                  Text('${endDate}')
                ],
              ),

              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                      setState((){
                        startDate = selectedDate;
                      });

                    },
                    child: const Text('To'),
                  ),
                  Text('${startDate}'),
                ],
              ),


              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  hint: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as String;
                    });
                  },
                  buttonHeight: 40,
                  buttonWidth: 140,
                  itemHeight: 40,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print(startDate);
                  print(endDate);
                  _getData();
                },
                child: const Text('Go'),
              ),
            ],
          ),
          Consumer<EarthQuakeProvider>(
            builder: (context, provider, child) => earthQuakeProvider.hasDataLoaded ? Expanded(
              child: ListView.builder(
                itemCount: provider.responseModel!.features!.length,
                itemBuilder: (context, index) {
                  final response = provider.responseModel!.features![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey[300],
                      child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal,

                          ),

                          height: 50,
                          width: 50,
                          child: Center(child: Text('${response.properties!.mag}', textAlign: TextAlign.center,)),
                        ),
                        title: provider.responseModel!.features![index].properties!.place != 'null' ? Text('${provider.responseModel!.features![index].properties!.place}') : Text('No place'),
                        subtitle: Text('on ${getFormattedDateTime(provider.responseModel!.features![index].properties!.time!, 'MMM-d hh:mm a')}'),
                      ),
                    ),
                  );
                },
              ),
            ) : Center(
              child: Text('No data loaded'),
            ),
          )
        ],
      ),
    );
  }
}
