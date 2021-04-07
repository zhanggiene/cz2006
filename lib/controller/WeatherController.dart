class WeatherController {
  String forecast;
  String imageURL;

  String imageFromForecast(String forecast) {
    String ans = 'images/weather-cloudy.png';
    if (forecast.contains('cloudy')) {
      ans = 'images/weather-cloudy.png';
    }
    if (forecast.contains('rains') || (forecast.contains('showers'))) {
      ans = 'images/weather-rain.png';
    }
    if (forecast.contains('thundery showers')) {
      ans = 'images/weather-thundery-shower.png';
    }
    return ans;
  }
}
