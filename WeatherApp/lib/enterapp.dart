import 'package:flutter/material.dart';
import 'package:weather_app/weatherscreen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome Screen',
        )
      ),

      body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WeatherScreen()));
                    },
                    child: const Text('Enter the app')),
              ],
            )
          ],
        )

    );
  }
}
