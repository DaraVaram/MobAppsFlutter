import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  String myPosition = '';
  Future<Position>? position;
  // late Future<Position> position;

  void initState()
  {
    super.initState();
    position = getPosition_withThen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Current Location')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(

              child: FutureBuilder(
                future: position,
                builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    myPosition = snapshot.data.toString();

                    return Column(
                      children: [
                        Center(child: Text('Longitude: ${snapshot.data?.longitude.toString()}')),
                        Center(child: Text('Latitude: ${snapshot.data?.latitude.toString()}'))
                      ],
                    );
                  } else {
                    return const Text('');
                  }
                },
              ),

            ),

          ],
        )
    );
  }

  Future<Position> getPosition() async {

    await Geolocator.requestPermission();
    await Geolocator.isLocationServiceEnabled();
    await Future.delayed(const Duration(seconds: 1));

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  Future<Position> getPosition_withThen() {
    // Request permission first
    return Geolocator.requestPermission().then((permission) {
      // Check if location services are enabled and wait for a second
      return Geolocator.isLocationServiceEnabled().then((isLocationServiceEnabled) {
        if (!isLocationServiceEnabled) {
          throw Exception('Location services are disabled.');
        }
        return Future.delayed(const Duration(seconds: 1)).then((_) {
          // Finally, get the current position
          return Geolocator.getCurrentPosition();
        }
        );
      }
      );
    }
    );
  }

}
