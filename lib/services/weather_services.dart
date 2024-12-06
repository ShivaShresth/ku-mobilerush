import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:weatherku/models/weather_models.dart';

class WeatherService {
  //static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
 String? BASE_URL;
 //static const BASE_URL="https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);



  Future<Weather> getWeather(String cityName) async {
    try {
print("helos${cityName}");
      final response = await http.get(Uri.parse(
          //"$BASE_URL?q=$cityName&appid=$apiKey&units=metric"
BASE_URL= "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=ddbf071c3cd3d6e5a1a9373851c1b8fe",    

          ));
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Failed to load weather data: $e");
    }
  }

  getCurrentCity() {}

  // Future<String> getCurrentCity() async {
  //   try {
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         position.latitude, position.longitude);
  //     String? city = placemarks[0].locality;
  //     print("This is hool${city}");
  //     return city ?? "";
  //   } catch (e) {
  //     throw Exception("Failed to fetch current city: $e");
  //   }
  // }
}
