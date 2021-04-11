class WeatherController {
  String forecast;
  String imageURL;

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
