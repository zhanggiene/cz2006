class Weather2Hour {
  dynamic forecast;

  Weather2Hour({this.forecast});

  factory Weather2Hour.fromJson(Map<String, dynamic> json) {
    // print(json['items'][0]['forecasts'][3]);
    return Weather2Hour(
      forecast: json['items'][0]['forecasts'][3]['forecast'],
    );
  }
}

class Weather24Hour {
  dynamic forecast;
  dynamic humidity;
  dynamic temperature;
  dynamic datetime;

  Weather24Hour(
      {this.forecast, this.humidity, this.temperature, this.datetime});

  factory Weather24Hour.fromJson(Map<String, dynamic> json) {
    // print(json['items'][0]['general']);
    return Weather24Hour(
        forecast: json['items'][0]['general']['forecast'],
        humidity: json['items'][0]['general']['relative_humidity']['high'],
        temperature: json['items'][0]['general']['temperature']['high']);
  }
}

class Weather4Days {
  dynamic firstDay;
  dynamic secondDay;
  dynamic thirdDay;
  dynamic forthDay;

  Weather4Days({this.firstDay, this.secondDay, this.thirdDay, this.forthDay});

  factory Weather4Days.fromJson(Map<String, dynamic> json) {
    // print(json['items'][0]['forecasts'][0]);
    dynamic first = json['items'][0]['forecasts'][0];
    dynamic second = json['items'][0]['forecasts'][1];
    dynamic third = json['items'][0]['forecasts'][2];
    dynamic forth = json['items'][0]['forecasts'][3];

    Map<int, String> weekday = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun'
    };
    return Weather4Days(
      firstDay: Weather24Hour(
        forecast: first['forecast'],
        humidity: first['relative_humidity']['high'],
        temperature: first['temperature']['high'],
        datetime: weekday[DateTime.parse(first['timestamp']).weekday.toInt()],
      ),
      secondDay: Weather24Hour(
        forecast: second['forecast'],
        humidity: second['relative_humidity']['high'],
        temperature: second['temperature']['high'],
        datetime: weekday[DateTime.parse(second['timestamp']).weekday.toInt()],
      ),
      thirdDay: Weather24Hour(
        forecast: third['forecast'],
        humidity: third['relative_humidity']['high'],
        temperature: third['temperature']['high'],
        datetime: weekday[DateTime.parse(third['timestamp']).weekday.toInt()],
      ),
      forthDay: Weather24Hour(
        forecast: forth['forecast'],
        humidity: forth['relative_humidity']['high'],
        temperature: forth['temperature']['high'],
        datetime: weekday[DateTime.parse(forth['timestamp']).weekday.toInt()],
      ),
    );
  }
}
