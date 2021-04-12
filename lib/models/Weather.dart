class Weather2Hour {
  dynamic forecast;

  Weather2Hour({this.forecast});

  factory Weather2Hour.fromJson(Map<String, dynamic> json) {
    return Weather2Hour(
      forecast: json['items'][0]['forecasts'][3]['forecast'],
    );
  }
}

class WeatherHourly {
  dynamic forecast;
  dynamic iconString;
  dynamic temp_min;
  dynamic temp_max;
  dynamic datetime;

  WeatherHourly(
      {this.forecast,
      this.iconString,
      this.temp_min,
      this.temp_max,
      this.datetime});

  factory WeatherHourly.fromJson(Map<String, dynamic> json) {
    return WeatherHourly(
        forecast: json['weather'][0]['description'],
        iconString: json['weather'][0]['icon'],
        temp_min: json['main']['temp_min'],
        temp_max: json['main']['temp_max'],
        datetime: DateTime.parse(json['dt']));
  }
}

class Weather4DaysHourly {
  dynamic firstDay;
  dynamic secondDay;
  dynamic thirdDay;
  dynamic forthDay;

  Weather4DaysHourly(
      {this.firstDay, this.secondDay, this.thirdDay, this.forthDay});

  factory Weather4DaysHourly.fromJson(Map<String, dynamic> json) {
    dynamic first = json['list'][0];
    dynamic second = json['list'][24];
    dynamic third = json['list'][48];
    dynamic forth = json['list'][72];

    Map<int, String> weekday = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun'
    };
    return Weather4DaysHourly(
      firstDay: WeatherHourly(
          forecast: first['weather'][0]['description'],
          iconString: first['weather'][0]['icon'],
          temp_min: first['main']['temp_min'],
          temp_max: first['main']['temp_max'],
          datetime: DateTime.parse(first['dt'])),
      secondDay: WeatherHourly(
          forecast: second['weather'][0]['description'],
          iconString: second['weather'][0]['icon'],
          temp_min: second['main']['temp_min'],
          temp_max: second['main']['temp_max'],
          datetime: DateTime.parse(first['dt'])),
      thirdDay: WeatherHourly(
          forecast: third['weather'][0]['description'],
          iconString: third['weather'][0]['icon'],
          temp_min: third['main']['temp_min'],
          temp_max: third['main']['temp_max'],
          datetime: DateTime.parse(third['dt'])),
      forthDay: WeatherHourly(
          forecast: forth['weather'][0]['description'],
          iconString: forth['weather'][0]['icon'],
          temp_min: forth['main']['temp_min'],
          temp_max: forth['main']['temp_max'],
          datetime: DateTime.parse(forth['dt'])),
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
    print(json['items'][0]['general']['forecast']);
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
