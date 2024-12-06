import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherku/models/weather_models.dart';
import 'package:weatherku/services/weather_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   String cityName = 'kathmandu';
      String _cityName = 'kathmandu';

   String _apiKey = 'ddbf071c3cd3d6e5a1a9373851c1b8fe';
  String _weatherData = '';
  bool _isLoading = false;

  get http => null;
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
      final weather=await _weatherService.getWeather(cityName!);
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
    //_fetchWeather();
  }

Future<String> getCurrentCity() async {
  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Set a timeout for the reverse geocoding request
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    ).timeout(Duration(seconds: 10), onTimeout: () {
      throw Exception("Timeout: Reverse geocoding took too long");
    });

    String? city = placemarks[0].locality;
    return city ?? "Unknown City";
  } catch (e) {
    print("Error: $e");
    return "Unable to fetch city";
  }
}


  // Future<void> _fetchWeather() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   String cityName=await getCurrentCity();

  //   final response = await http.get(Uri.parse(
  //       'http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric'));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _weatherData = response.body;
  //       _isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       _weatherData = 'Error fetching weather data';
  //       _isLoading = false;
  //     });
  //   }
  // }

  Future<void> _fetchWeathera() async {
    setState(() {
      _isLoading = true;
    });

    // First, get the city and location
    await getCurrentCity();

    // Fetch weather data using the current city name
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$_apiKey&units=metric'));

    // Check if the response is empty
    if (response.body.isEmpty) {
      setState(() {
        _weatherData = 'Empty response from API';
        _isLoading = false;
      });
      return;
    }

    // Print the response body to debug
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        _weatherData = response.body;
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherData = 'Error fetching weather data: ${response.statusCode}';
        _isLoading = false;
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //  _fetchWeather();
  //   // _buildWeatherDisplay();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white], // Gradient colors
            begin: Alignment.topLeft, // Start point of the gradient
            end: Alignment.bottomRight, // End point of the gradient
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          //color: Colors.grey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      //  color: Colors.amber
                      ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        //color: Colors.pink,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Stack(
                              children: [
                                Positioned(
                                    top: 0,
                                    right: 3,
                                    child: Text(
                                      ".C",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )),
                                Container(
                                    height: 60,
                                    width: 60,
                                    child: Text(
                                      "40",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 2,
                        height: 60,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Container(
                          // color: Colors.green,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.pin_drop,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Kathmandu${_weather?.cityName}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 13),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Text("Sunny",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 13)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.cloud_outlined,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Text("Friday,6",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 13)),
                                      Text(" December",
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 13))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          // Positioned(
                                          //     top: 0,
                                          //     right: 3,
                                          //     child: Text(
                                          //       ".C",
                                          //       style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontSize: 14),
                                          //     )),
                                          Container(
                                              child: Text(
                                            "Feels Like 42",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset("assets/5.png",height: 80,width: 80,fit: BoxFit.cover,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          offset: Offset(4,
                              4), // The position of the shadow (horizontal, vertical)
                          blurRadius: 8, // How blurry the shadow is
                          spreadRadius: 2, // How far the shadow spreads
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Icon(Icons.cloud)),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "27%",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "Precipitation",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Icon(Icons.speed)),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("760 mm",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text("Atm Pressure",
                                        style: TextStyle(color: Colors.grey))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Icon(Icons.water)),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("27 km/hr",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text("Wind Speed",
                                        style: TextStyle(color: Colors.grey))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6))),
                                    child: Icon(Icons.bubble_chart)),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("35%",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text("Humidity",
                                        style: TextStyle(color: Colors.grey))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text("Extreme Heat ",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    Text(
                      "Apply Sunscrean",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  //color: Colors.pink,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.,
                    children: [
                      Expanded(
                        child: Text("Recommended Places",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(Icons.arrow_forward_ios))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          offset: Offset(4,
                              4), // The position of the shadow (horizontal, vertical)
                          blurRadius: 8, // How blurry the shadow is
                          spreadRadius: 2, // How far the shadow spreads
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 90,
                              height: 90,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                //  color: Colors.amberAccent,
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    "assets/1.webp",
                                    fit: BoxFit.cover,
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kathmandu",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("15 KM",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("City full of temples and monkeys",
                                  style: TextStyle(
                                      color: Colors.brown,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          offset: Offset(4,
                              4), // The position of the shadow (horizontal, vertical)
                          blurRadius: 8, // How blurry the shadow is
                          spreadRadius: 2, // How far the shadow spreads
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 90,
                              height: 90,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                //  color: Colors.amberAccent,
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    "assets/1.webp",
                                    fit: BoxFit.cover,
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Chitwan",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("50 KM",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("Meet the wildlife",
                                  style: TextStyle(
                                      color: Colors.brown,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          offset: Offset(4,
                              4), // The position of the shadow (horizontal, vertical)
                          blurRadius: 8, // How blurry the shadow is
                          spreadRadius: 2, // How far the shadow spreads
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 90,
                              height: 90,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                //  color: Colors.amberAccent,
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    "assets/1.webp",
                                    fit: BoxFit.cover,
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pokhara",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("90 KM",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("Tourist's hub",
                                  style: TextStyle(
                                      color: Colors.brown,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          offset: Offset(4,
                              4), // The position of the shadow (horizontal, vertical)
                          blurRadius: 8, // How blurry the shadow is
                          spreadRadius: 2, // How far the shadow spreads
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 90,
                              height: 90,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                //  color: Colors.amberAccent,
                              ),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    "assets/1.webp",
                                    fit: BoxFit.cover,
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Dhandadhi",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("185 KM",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("Beauty of Far-west.",
                                  style: TextStyle(
                                      color: Colors.brown,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Chances of rain",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Heavy",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text("Rainy",
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(
                                height: 30,
                              ),
                              Text("Rain",
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                               SizedBox(
                                height: 40,
                              ),
                              Container(
                                width: 8,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey),
                              ),
                              Text(
                                "Sun",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                            
                              Container(
                                width: 8,
                                height: 90,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey),
                              ),
                              Text(
                                "Mon",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                               SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: 8,
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey),
                              ),
                              Text(
                                "Tue",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 8,
                                height: 90,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey),
                              ),
                              Text(
                                "Wed",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                               SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 8,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey),
                              ),
                             
                              Text(
                                "Thu",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                               SizedBox(
                                height: 70,
                              ),
                              Container(
                                width: 8,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.blue.shade900),
                              ),
                              Text(
                                "Fri",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 8,
                                height: 90,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.grey),
                              ),
                              Text(
                                "Sat",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildWeatherDisplay() {
    final weather = json.decode(_weatherData);
    final cityName = weather['name'];
    final temperature = weather['main']['temp'];
    final weatherDescription = weather['weather'][0]['description'];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$cityName Weather',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Temperature: $temperature°C',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Condition: $weatherDescription',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
