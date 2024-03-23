import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:weather_app/cityweatherpage.dart';

const String api = '77964d394ab04ed2bf4193205242203';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  List<Future<Map<String, dynamic>>> futureWeatherData = [];
  TextEditingController cityController = TextEditingController();
  String myPosition = '';
  Future<Position>? position;

  @override
  void initState() {
    futureWeatherData.add(getWeatherData('Sharjah'));
    futureWeatherData.add(getWeatherData('Dubai'));
    futureWeatherData.add(getWeatherData('Ajman'));
    futureWeatherData.add(getWeatherData('Abu Dhabi'));
    futureWeatherData.add(getWeatherData('Ras Al Khaimah'));
    futureWeatherData.add(getWeatherData('Fujairah '));
    fetchUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.blueGrey,
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Welcome to the Weather app. This is weather. App.',
                  style: TextStyle(
                    fontSize: 30,
                  )
                ),
              )
            ],
          )

      ),
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: const <Widget>[
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.sunny_snowing,
                color: Colors.yellow,
              )
          )
        ],
        backgroundColor: Colors.lightBlue,
      ),

      body:
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: futureWeatherData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<Map<String, dynamic>>(
                      future: futureWeatherData[index],
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          var weatherData = snapshot.data!;
                          var location = weatherData['location']['name'];
                          var currentWeather = weatherData['current']['temp_c'];
                          var condition = weatherData['current']['condition']['text'];
                          var windKph = weatherData['current']['wind_kph'];
                          var humidity = weatherData['current']['humidity'];
                          var feelsLike = weatherData['current']['feelslike_c'];


                          List<Map<String, dynamic>> fiveDayForecast = [];

                          var forecastDays = weatherData['forecast']['forecastday'] as List;
                          for (var i = 0; i < forecastDays.length; i++) {
                            var dayData = forecastDays[i]['day'];
                            var maxTemp = dayData['maxtemp_c'];
                            var minTemp = dayData['mintemp_c'];
                            var date = forecastDays[i]['date'];

                            fiveDayForecast.add({
                              'date': date,
                              'maxTemp': maxTemp,
                              'minTemp': minTemp,
                            });
                          }



                          return GestureDetector(
                            onTap: () {
                              _showWeatherDialog(context, location, currentWeather, condition, windKph, humidity, feelsLike, fiveDayForecast);
                              //_showWeatherDialog(context, location, currentWeather, condition, wind_kph, humidity, feels_like);
                            },
                            child: Card(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Weather in $location: $currentWeather°C',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Card(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Error fetching data',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }
                        return const Card(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                    );
                  }),
            ),
            Column(
              children: [
                const Text(
                  'Search for a city by Name: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Form(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: cityController,
                              decoration: const InputDecoration(labelText: 'City Name'),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      searchCityWeather(context, cityController.text);
                                    },
                                    child: const Text(
                                      'Search',
                                    )
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      searchCityWeatherNewPage(context, cityController.text);
                                    },
                                    child: const Text('Search new page'))
                              ],
                            )
                          ],
                        )
                    )
                ),
              ],

            ),
            const Text(
                'Your current location: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )
            ),
            FutureBuilder(
              future: position,
              builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Text(snapshot.data.toString());
                } else {
                  return const Text('NO LOCATION DATA AVAILABLE');
                }
              },
            ),
            SizedBox(
              height: 180,
              child: Image.asset(
                'assets/norway.jpg',
                fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getWeatherData(String location) async {
    final url = 'http://api.weatherapi.com/v1/forecast.json?key=$api&q=$location&days=5&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  void searchCityWeather(BuildContext context, String city) async {
    try {
      final weatherData = await getWeatherData(city);

      _showWeatherDialog(context, city,
          weatherData['current']['temp_c'],
          weatherData['current']['condition']['text'],
          weatherData['current']['wind_kph'], weatherData['current']['humidity'],
          weatherData['current']['feelslike_c'], weatherData['forecast']['forecastday']);


    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("City not found"),
            content: const Text("This city does not exist in the database. Please try again."),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void searchCityWeatherNewPage(BuildContext context, String city) async {
    try {
      final weatherData = await getWeatherData(city);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return CityWeatherDetailsPage(
            city: city,
            tempC: weatherData['current']['temp_c'],
            conditionText: weatherData['current']['condition']['text'],
            windKph: weatherData['current']['wind_kph'],
            humidity: weatherData['current']['humidity'],
            feelsLikeC: weatherData['current']['feelslike_c'],
            forecastDays: weatherData['forecast']['forecastday'],
          );
        }),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("City not found"),
            content: const Text("This city does not exist in the database. Please try again."),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  Future<Position> getPosition() async {
    await Geolocator.requestPermission();
    await Geolocator.isLocationServiceEnabled();
    await Future.delayed(const Duration(seconds: 1));
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  void fetchUserLocation() async {
    position = getPosition();
    position!.then((pos) {
      setState(() {
        myPosition = 'Lat: ${pos.latitude}, Long: ${pos.longitude}';
      });
    }).catchError((e) {
      print(e);
    });
  }

}


void _showWeatherDialog(context, location, currentWeather, condition, windKph, humidity, feelsLike, fiveDayForecast) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('Weather in $location:'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Temperature: $currentWeather°C'),
                  Text('Condition: $condition'),
                  Text('Wind speed: $windKph kph'),
                  Text('Humidity: $humidity%'),
                  Text('Feels like: $feelsLike°C'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // print(fiveDayForecast);
                        _showForecastDialog(context, location, fiveDayForecast);
                      },
                      child: const Text('Check 5-day forecast')
                  )
                ],
              ),
            )
        );

      }
  );
}


void _showForecastDialog(BuildContext context, String location, List<Map<String, dynamic>> fiveDayForecast) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('5-day forecast for $location:'),
        content: SizedBox(
          height: 200,
          width: double.maxFinite,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: fiveDayForecast.length,
            itemBuilder: (context, index) {
              final dayForecast = fiveDayForecast[index];
              return Card(
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Date: ${dayForecast['date']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Max: ${dayForecast['maxTemp']}°C'),
                      Text('Min: ${dayForecast['minTemp']}°C'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

