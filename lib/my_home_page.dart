import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/MyForecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';
import 'additonal_information.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> myweather;
  Future<Map<String, dynamic>> getCurrentWeatherInfo() async {
    String city = "London";
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city,uk&APPID=$weatherapi'));
      final result = jsonDecode(res.body);
      print(result);
      if (result['cod'] != '200') {
        throw 'An error has occured';
      }

      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    myweather = getCurrentWeatherInfo();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  myweather = getCurrentWeatherInfo();
                });
              },
              icon: const Icon(Icons.refresh)),
        ],
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: myweather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final result = snapshot.data!;
          final main_temp = result['list'][0]['main']['temp'];
          final main_pressure = result['list'][0]['main']['pressure'];
          final main_humidity = result['list'][0]['main']['humidity'];
          final main_wind = result['list'][0]['wind']['speed'];
          final weather = result['list'][0]['weather'][0]['main'];
          final IconData icon;
          if (weather == "Rain") {
            icon = Icons.umbrella_rounded;
          } else if (weather == "Clouds") {
            icon = Icons.cloud;
          } else {
            icon = Icons.sunny;
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 15,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$main_temp °K",
                                  style: const TextStyle(fontSize: 40),
                                ),
                                Icon(
                                  icon,
                                  size: 50,
                                ),
                                Text(
                                  weather,
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Weather forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),

                /*SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      for (int i = 1; i <= 5; i++) ...[
                        MyForecast(
                            temp: result['list'][i]['main']['temp'].toString(),
                            time: "3:00"),
                      ],
                    ],
                  ),
                ),*/
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, int index) {
                        final time = DateTime.parse(
                            result['list'][index + 1]['dt_txt'].toString());
                        return MyForecast(
                            temp: result['list'][index + 1]['main']['temp']
                                .toString(),
                            time: DateFormat.j().format(time));
                      }),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditonalInformation(
                        icon: Icons.water_drop,
                        temperature: "$main_humidity",
                        climate: "Humidity"),
                    AdditonalInformation(
                        icon: Icons.air,
                        temperature: main_wind.toString(),
                        climate: "Wind Speed"),
                    AdditonalInformation(
                        icon: Icons.heat_pump,
                        temperature: "$main_pressure",
                        climate: "Pressure")
                  ],
                )
              ],
            ),
          );
        },
      ),
    ));
  }
}
