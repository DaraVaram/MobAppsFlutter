import 'package:flutter/material.dart';

class DeepTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Its all widgets!'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlutterLogo(),
                  Text('Flutter is amazing.'),
                ],
              ),
              Text('Let\'s find out how deep the rabbit hole goes.'),
            ],
          )
      ),
    );
  }
}