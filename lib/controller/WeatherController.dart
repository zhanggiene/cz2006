import 'dart:convert';

import 'package:cz2006/models/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherController {
  String forecast;
  String imageURL;
  final apiKey = 'f9a63e951c07e84f0023a4512c74f111';

  Future<WeatherHourly> fetchCurrentWeather() async {
    final response = await http.get(Uri.https('api.openweathermap.org',
        'data/2.5/weather?q=Singapore&APPID=f9a63e951c07e84f0023a4512c74f111'));
    print(response.statusCode);
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return WeatherHourly.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
  }

  Future<Weather4DaysHourly> fetch4DaysWeather() async {
    final response = await http.get(Uri.https('pro.openweathermap.org',
        'data/2.5/weather?q=Singapore&APPID=f9a63e951c07e84f0023a4512c74f111'));
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      return Weather4DaysHourly.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
    }
  }

  String imageFromForecast(String forecast) {
    String ans = 'images/weather-cloudy.png';
    if (forecast.contains('cloudy') || forecast.contains('Cloudy')) {
      ans = 'images/weather-cloudy.png';
    }
    if (forecast.contains('rains') ||
        (forecast.contains('showers')) ||
        forecast.contains('Rains') ||
        (forecast.contains('Showers'))) {
      ans = 'images/weather-rain.png';
    }
    if (forecast.contains('thundery showers') ||
        forecast.contains('Thundery Showers')) {
      ans = 'images/weather-thundery-shower.png';
    }
    return ans;
  }
}
