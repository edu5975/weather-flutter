import 'dart:convert';

import 'package:flutter_weather_app/api/key.dart';
import 'package:flutter_weather_app/models/weather_locations.dart';
import 'package:http/http.dart' show Client;

class ApiWeather {
  Client http = Client();

  Future<WeatherLocation> getCity(String city) async {
    String url =
        'http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${KeysApi.weatherKey}&units=metric';
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var esp = jsonDecode(response.body);
      WeatherLocation city = WeatherLocation().fromJson(esp);
      return city;
    } else {
      return null;
    }
  }

  Future<List<WeatherLocation>> getCities(List<String> cities) async {
    List<WeatherLocation> weather = List<WeatherLocation>();
    for (var city in cities) {
      String url =
          'http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${KeysApi.weatherKey}&units=metric';
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var esp = jsonDecode(response.body);
        WeatherLocation city = WeatherLocation().fromJson(esp);
        weather.add(city);
      }
    }
    return weather;
  }
}
