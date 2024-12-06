import 'package:flutter/material.dart';
import 'package:weatherku/models/weather_models.dart';
import 'package:weatherku/services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}
class _WeatherPageState extends State<WeatherPage> {
  //api key
//  final _weatherService=WeatherService('23474f85c62938615d08f2d30942d65e');
 // final _weatherService=WeatherService('909d2feab4d699b925b8def2f51413ab');
    final _weatherService=WeatherService('ddbf071c3cd3d6e5a1a9373851c1b8fe');


  Weather? _weather;

  //fetch weahter
  _fetchWeather()async{  
    //get the current city
    String cityName=await _weatherService.getCurrentCity();

    //get weather for city
    try{  
      final weather=await _weatherService.getWeather(cityName);
      setState(() {
        _weather=weather;
      });
    }

    catch(e){  
      print(e);
    }
  }
  //weather animations

  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(  
        child: Column(  
          mainAxisAlignment: MainAxisAlignment.center,
          children: [  
            //city Name
            Text(_weather?.cityName??"Loading city.."),

            //temperature
          //  Text("${_weather?.temperature.round()}C")
          // Text("${((_weather?.temperature ?? 0) - 273.15).toStringAsFixed(0)}°C"),
          Text(
  _weather != null && _weather?.temperature!= -273
      ? "${((_weather?.temperature ?? 0) - 273.15).toStringAsFixed(0)}°C"
      : "Loading...",
),


          ],
        ),
      ),
    );
  }
}