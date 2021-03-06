import 'dart:async';
import 'dart:convert';

import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/controller/WeatherController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/User.dart';
import 'package:cz2006/models/Weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User currentUser = locator.get<UserController>().currentuser;
  DateTime now = DateTime.now();
  WeatherHourly currentWeather;
  Weather4DaysHourly fourDaysWeather;
  Weather2Hour _2HourWeather;
  Weather24Hour _24HourWeather;
  Weather4Days _4DaysWeather;
  int _likedNum;

  Future<int> getLikedNum() async {
    return await locator.get<UserController>().getLikedNumber();
  }

  Future<List<Object>> fetchData() async {
    // currentWeather = await WeatherController().fetchCurrentWeather();
    // fourDaysWeather = await WeatherController().fetch4DaysWeather();
    _2HourWeather = await fetchWeather2Hour();
    _24HourWeather = await fetchWeather24Hour();
    // _4DaysWeather = await fetchWeather4Days();
    _likedNum = await getLikedNum();
    return [
      // currentWeather,
      // fourDaysWeather,
      _2HourWeather,
      _24HourWeather,
      // _4DaysWeather,
      _likedNum,
    ];
  }

  Future<Weather2Hour> fetchWeather2Hour() async {
    final response = await http.get(
        Uri.https('api.data.gov.sg', 'v1/environment/2-hour-weather-forecast'));
    if (response.statusCode == 200) {
      return Weather2Hour.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
  }

  Future<Weather24Hour> fetchWeather24Hour() async {
    final response = await http.get(Uri.https(
        'api.data.gov.sg', 'v1/environment/24-hour-weather-forecast'));
    if (response.statusCode == 200) {
      return Weather24Hour.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
  }

  Future<Weather4Days> fetchWeather4Days() async {
    final response = await http.get(
        Uri.https('api.data.gov.sg', 'v1/environment/4-day-weather-forecast'));
    if (response.statusCode == 200) {
      return Weather4Days.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData();

    return FutureBuilder<List<Object>>(
        future: fetchData(),
        builder: (context, AsyncSnapshot<List<Object>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          } else {
            // currentWeather = snapshot.data[0];
            // fourDaysWeather = snapshot.data[1];
            _2HourWeather = snapshot.data[0];
            _24HourWeather = snapshot.data[1];
            // _4DaysWeather = snapshot.data[1];
            _likedNum = snapshot.data[2];
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, right: 16.0, left: 16.0, bottom: 25.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/biglogo.png"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("  Hello ${currentUser.name}!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Text(
                                      "  Your posts have received ${_likedNum} ",
                                      style: TextStyle(fontSize: 16)),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 24.0,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Singapore reports
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "images/SG_report.png",
                            width: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text("SINGAPORE",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(thickness: 1.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Breeding areas reported",
                                  style: TextStyle(fontSize: 16)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "images/breeding.png",
                                    width: 70.0,
                                  ),
                                  Text(" 1,805",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Text("UPDATED AT: ${now.hour}:${now.minute}",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Fogging conducted",
                                  style: TextStyle(fontSize: 16)),
                              Row(
                                children: [
                                  Image.asset(
                                    "images/fogger.png",
                                    width: 30.0,
                                  ),
                                  Text(" 168",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text("Symptoms reported",
                                  style: TextStyle(fontSize: 16)),
                              Row(
                                children: [
                                  Image.asset(
                                    "images/symptoms.png",
                                    width: 30.0,
                                  ),
                                  Text(" 726",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      // Daily Tips
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "images/daily_tips.png",
                            width: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text("DAILY TIPS",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(thickness: 1.0),
                      Image.asset("images/dengue_prevent.png"),
                      // Weather
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "images/weather.png",
                            width: 30.0,
                          ),
                          SizedBox(width: 10.0),
                          Text("WEATHER",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Divider(thickness: 1.0),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // manually day 0
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(
                            //           top: 2.0, bottom: 2.0),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           SizedBox(width: 20),
                            //           Image.asset(
                            //             'images/cloudy.png',
                            //             width: 50,
                            //             // color: Colors.white,
                            //           ),
                            //           SizedBox(width: 20),
                            //           Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text("Today",
                            //                   style: TextStyle(
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //               Text("Clouds"),
                            //               Text("29" +
                            //                   String.fromCharCodes(
                            //                       Runes('\u00B0')) +
                            //                   "C"),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     )),
                            // // day 1
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(
                            //           top: 2.0, bottom: 2.0),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           SizedBox(width: 20),
                            //           Image.asset(
                            //             'images/rain.png',
                            //             width: 50,
                            //             // color: Colors.white,
                            //           ),
                            //           SizedBox(width: 20),
                            //           Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text("Tomorrow",
                            //                   style: TextStyle(
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //               Text("Light rain"),
                            //               Text("29" +
                            //                   String.fromCharCodes(
                            //                       Runes('\u00B0')) +
                            //                   "C"),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     )),
                            // // day 3
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(
                            //           top: 2.0, bottom: 2.0),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           SizedBox(width: 20),
                            //           Image.asset(
                            //             'images/rain.png',
                            //             width: 50,
                            //             // color: Colors.white,
                            //           ),
                            //           SizedBox(width: 20),
                            //           Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text("Wednesday",
                            //                   style: TextStyle(
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //               Text("Moderate rain"),
                            //               Text("29" +
                            //                   String.fromCharCodes(
                            //                       Runes('\u00B0')) +
                            //                   "C"),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     )),

                            // // day 3
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(
                            //           top: 2.0, bottom: 2.0),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.start,
                            //         children: [
                            //           SizedBox(width: 20),
                            //           Image.asset(
                            //             'images/rain.png',
                            //             width: 50,
                            //             // color: Colors.white,
                            //           ),
                            //           SizedBox(width: 20),
                            //           Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Text("Thursday",
                            //                   style: TextStyle(
                            //                       fontSize: 16,
                            //                       fontWeight: FontWeight.bold)),
                            //               Text("Light rain"),
                            //               Text("30" +
                            //                   String.fromCharCodes(
                            //                       Runes('\u00B0')) +
                            //                   "C"),
                            //             ],
                            //           ),
                            //         ],
                            //       ),
                            //     )),

                            /////////////////////////

                            // 2 hour nowcast
                            Card(
                                margin: EdgeInsets.only(bottom: 10),
                                color: Colors.green[200],
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 10),
                                      Image.asset(
                                        WeatherController().imageFromForecast(
                                            _2HourWeather.forecast),
                                        width: 50,
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Today ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text("${_2HourWeather.forecast}")
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            // 24 hour forecast
                            Card(
                                margin: EdgeInsets.only(bottom: 10),
                                color: Colors.green[200],
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 10),
                                      Image.asset(
                                        WeatherController().imageFromForecast(
                                            _24HourWeather.forecast),
                                        width: 50,
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Tomorrow forecast",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text("${_24HourWeather.forecast}"),
                                          Text(
                                            "${_24HourWeather.temperatureLow}" +
                                                String.fromCharCodes(
                                                    Runes('\u00B0')) +
                                                "C - " +
                                                "${_24HourWeather.temperatureHigh}" +
                                                String.fromCharCodes(
                                                    Runes('\u00B0')) +
                                                "C",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                            // 4 days forecast
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         SizedBox(width: 10),
                            //         Image.asset(
                            //           WeatherController().imageFromForecast(
                            //               _4DaysWeather.firstDay.forecast),
                            //           width: 50,
                            //         ),
                            //         SizedBox(width: 20),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //                 "${_4DaysWeather.firstDay.datetime}",
                            //                 style: TextStyle(
                            //                     fontSize: 16,
                            //                     fontWeight: FontWeight.bold)),
                            //             Text(
                            //                 "${_4DaysWeather.firstDay.forecast}"),
                            //             Text(
                            //                 "${_4DaysWeather.firstDay.temperatureLow}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C - " +
                            //                     "${_4DaysWeather.firstDay.temperatureHigh}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C",
                            //                 style: TextStyle(fontSize: 16)),
                            //           ],
                            //         )
                            //       ],
                            //     )),
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         SizedBox(width: 10),
                            //         Image.asset(
                            //           WeatherController().imageFromForecast(
                            //               _4DaysWeather.firstDay.forecast),
                            //           width: 50,
                            //         ),
                            //         SizedBox(width: 20),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //                 "${_4DaysWeather.secondDay.datetime}",
                            //                 style: TextStyle(
                            //                     fontSize: 16,
                            //                     fontWeight: FontWeight.bold)),
                            //             Text(
                            //                 "${_4DaysWeather.secondDay.forecast}"),
                            //             Text(
                            //                 "${_4DaysWeather.secondDay.temperatureLow}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C - " +
                            //                     "${_4DaysWeather.secondDay.temperatureHigh}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C",
                            //                 style: TextStyle(fontSize: 16)),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         SizedBox(width: 10),
                            //         Image.asset(
                            //           WeatherController().imageFromForecast(
                            //               _4DaysWeather.firstDay.forecast),
                            //           width: 50,
                            //         ),
                            //         SizedBox(width: 20),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //                 "${_4DaysWeather.thirdDay.datetime}",
                            //                 style: TextStyle(
                            //                     fontSize: 16,
                            //                     fontWeight: FontWeight.bold)),
                            //             Text(
                            //                 "${_4DaysWeather.thirdDay.forecast}"),
                            //             Text(
                            //                 "${_4DaysWeather.thirdDay.temperatureLow}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C - " +
                            //                     "${_4DaysWeather.thirdDay.temperatureHigh}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C",
                            //                 style: TextStyle(fontSize: 16)),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Card(
                            //     margin: EdgeInsets.only(bottom: 10),
                            //     color: Colors.green[200],
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         SizedBox(width: 10),
                            //         Image.asset(
                            //           WeatherController().imageFromForecast(
                            //               _4DaysWeather.firstDay.forecast),
                            //           width: 50,
                            //         ),
                            //         SizedBox(width: 20),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //                 "${_4DaysWeather.forthDay.datetime}",
                            //                 style: TextStyle(
                            //                     fontSize: 16,
                            //                     fontWeight: FontWeight.bold)),
                            //             Text(
                            //                 "${_4DaysWeather.forthDay.forecast}"),
                            //             Text(
                            //                 "${_4DaysWeather.forthDay.temperatureLow}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C - " +
                            //                     "${_4DaysWeather.forthDay.temperatureHigh}" +
                            //                     String.fromCharCodes(
                            //                         Runes('\u00B0')) +
                            //                     "C",
                            //                 style: TextStyle(fontSize: 16)),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                          ])
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
