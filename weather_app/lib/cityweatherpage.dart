import 'package:flutter/material.dart';

class CityWeatherDetailsPage extends StatelessWidget {
  final String city;
  final double tempC;
  final String conditionText;
  final double windKph;
  final int humidity;
  final double feelsLikeC;
  final List<dynamic> forecastDays;

  const CityWeatherDetailsPage({
    super.key,
    required this.city,
    required this.tempC,
    required this.conditionText,
    required this.windKph,
    required this.humidity,
    required this.feelsLikeC,
    required this.forecastDays,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in $city'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Temperature: $tempC°C', style: const TextStyle(fontSize: 18)),
              Text('Condition: $conditionText', style: const TextStyle(fontSize: 18)),
              Text('Wind speed: $windKph kph', style: const TextStyle(fontSize: 18)),
              Text('Humidity: $humidity%', style: const TextStyle(fontSize: 18)),
              Text('Feels like: $feelsLikeC°C', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              const Text('5-day Forecast:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ...forecastDays.map((day) {
                return Text('Day ${day['date']}: Max Temp: ${day['day']['maxtemp_c']}°C, Min Temp: ${day['day']['mintemp_c']}°C');
              }),
            ],
          ),
        ),
      ),
    );
  }
}
