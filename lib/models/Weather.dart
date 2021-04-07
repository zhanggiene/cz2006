class Weather2Hour {
  dynamic forecast;

  Weather2Hour({this.forecast});

  factory Weather2Hour.fromJson(Map<String, dynamic> json) {
    return Weather2Hour(
      forecast: json['items'][0]['forecasts'][3]['forecast'],
    );
  }
}

class Weather24Hour {
  dynamic forecast;
  dynamic temperatureLow;
  dynamic temperatureHigh;
  dynamic datetime;

  Weather24Hour(
      {this.forecast,
      this.temperatureLow,
      this.temperatureHigh,
      this.datetime});

  factory Weather24Hour.fromJson(Map<String, dynamic> json) {
    return Weather24Hour(
        forecast: json['items'][0]['general']['forecast'],
        temperatureLow: json['items'][0]['general']['temperature']['low'],
        temperatureHigh: json['items'][0]['general']['temperature']['high']);
  }
}

class Weather4Days {
  dynamic firstDay;
  dynamic secondDay;
  dynamic thirdDay;
  dynamic forthDay;

  Weather4Days({this.firstDay, this.secondDay, this.thirdDay, this.forthDay});

  factory Weather4Days.fromJson(Map<String, dynamic> json) {
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
        temperatureLow: first['temperature']['low'],
        temperatureHigh: first['temperature']['high'],
        datetime: weekday[DateTime.parse(first['timestamp']).weekday.toInt()],
      ),
      secondDay: Weather24Hour(
        forecast: second['forecast'],
        temperatureLow: second['temperature']['low'],
        temperatureHigh: second['temperature']['high'],
        datetime: weekday[DateTime.parse(second['timestamp']).weekday.toInt()],
      ),
      thirdDay: Weather24Hour(
        forecast: third['forecast'],
        temperatureLow: third['temperature']['low'],
        temperatureHigh: third['temperature']['high'],
        datetime: weekday[DateTime.parse(third['timestamp']).weekday.toInt()],
      ),
      forthDay: Weather24Hour(
        forecast: forth['forecast'],
        temperatureLow: forth['temperature']['low'],
        temperatureHigh: forth['temperature']['high'],
        datetime: weekday[DateTime.parse(forth['timestamp']).weekday.toInt()],
      ),
    );
  }
}
