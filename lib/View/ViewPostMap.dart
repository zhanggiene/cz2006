import 'dart:async';
import 'dart:convert';

import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/User.dart';
import 'package:cz2006/models/Weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User currentUser = locator.get<UserController>().currentuser;
  DateTime now = DateTime.now();
  Weather2Hour _2HourWeather;
  Weather24Hour _24HourWeather;
  Weather4Days _4DaysWeather;

  void fetchWeather() async {
    // setState(() {});
    _2HourWeather = await fetchWeather2Hour();
    _24HourWeather = await fetchWeather24Hour();
    _4DaysWeather = await fetchWeather4Days();
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
    fetchWeather();
    print(_4DaysWeather.firstDay.datetime);
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
                  Text("   Hello ${currentUser.name}!",
                      style: TextStyle(fontSize: 16)),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                                  fontSize: 30, fontWeight: FontWeight.bold)),
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
                      Text("Fogging conducted", style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Image.asset(
                            "images/fogger.png",
                            width: 40.0,
                          ),
                          Text(" 168",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text("Symptoms reported", style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Image.asset(
                            "images/symptoms.png",
                            width: 30.0,
                          ),
                          Text(" 726",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(thickness: 1.0),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.green[200],
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Text("2-hour nowcast",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(" ${_2HourWeather.forecast}")
                            ],
                          ),
                        )),
                    Card(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.green[200],
                        child: Column(
                          children: [
                            Text(" ${_4DaysWeather.firstDay.datetime}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(" ${_4DaysWeather.firstDay.forecast}"),
                            Text(
                                " ${_4DaysWeather.firstDay.temperature}" +
                                    String.fromCharCodes(Runes('\u00B0')) +
                                    "C",
                                style: TextStyle(fontSize: 16)),
                          ],
                        )),
                    Card(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.green[200],
                        child: Column(
                          children: [
                            Text(" ${_4DaysWeather.secondDay.datetime}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(" ${_4DaysWeather.secondDay.forecast}"),
                            Text(
                                " ${_4DaysWeather.secondDay.temperature}" +
                                    String.fromCharCodes(Runes('\u00B0')) +
                                    "C",
                                style: TextStyle(fontSize: 16)),
                          ],
                        )),
                    Card(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.green[200],
                        child: Column(
                          children: [
                            Text(" ${_4DaysWeather.thirdDay.datetime}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(" ${_4DaysWeather.thirdDay.forecast}"),
                            Text(
                                " ${_4DaysWeather.thirdDay.temperature}" +
                                    String.fromCharCodes(Runes('\u00B0')) +
                                    "C",
                                style: TextStyle(fontSize: 16)),
                          ],
                        )),
                    Card(
                        margin: EdgeInsets.only(bottom: 10),
                        color: Colors.green[200],
                        child: Column(
                          children: [
                            Text(" ${_4DaysWeather.forthDay.datetime}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(" ${_4DaysWeather.forthDay.forecast}"),
                            Text(
                                " ${_4DaysWeather.forthDay.temperature}" +
                                    String.fromCharCodes(Runes('\u00B0')) +
                                    "C",
                                style: TextStyle(fontSize: 16)),
                          ],
                        )),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
