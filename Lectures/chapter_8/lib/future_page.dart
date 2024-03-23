import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:async';


class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {

  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back from the Future'),
      ),
      body: Center(
        child: Column(children: [
          const Spacer(),
          ElevatedButton(
            child: const Text ('GO! – Test getData() Api'),
            onPressed: () {

              getData().then(
                      (value) {
                    result= value.body.toString().substring(0,450);
                    setState(() {}) ;

                  }).catchError((_) {
                result = 'An error occurred: ${_.toString()}';
                setState (() {});
              });
            },
          ),

          // ElevatedButton(
          //   child: const Text ('GO! – Test getData() Api'),
          //   onPressed: () async {
          //     try {
          //       final response = await getData();
          //       final String responseBody = response.body.toString().substring(0, 450);
          //       result = responseBody;
          //       setState(() {
          //       });
          //     } catch (e) {
          //       result = 'An error occured: ${e.toString()}';
          //       setState(() {
          //
          //       });
          //     }
          //   },
          // ),

          const Spacer(),
          ElevatedButton(
            child: Text('GO! Test count with await'),
            onPressed: () {
              count();
            },
          ),
          const Spacer(),
          // ElevatedButton(
          //   onPressed: () async {
          //     int rst = await count();
          //     result = rst.toString();
          //     setState(() {
          //     });
          //   },
          //   child: Text('GO! Test count with await, another method'),
          // ),
          ElevatedButton(
            child: const Text('GO!-Test returnError()'),
            onPressed: () {
              returnError().then((value) {
                setState(() {
                  result = 'Success';
                });
              }).catchError((onError)
              {
                setState(()
                {
                  result = onError.toString();
                });
              }).whenComplete(() => print('Complete'));  },
          ),

          // ElevatedButton(
          //   child: const Text('Another way to do this'),
          //   onPressed: () async {
          //     handleError();
          //     setState(() {
          //     });
          //   },
          // ),
          const Spacer(),
          Text(result),
          const Spacer(),
          const CircularProgressIndicator(),
          const Spacer(),
        ]),
      ),
    );
  }

  Future<Response> getData() async {

    final String authority = 'www.googleapis.com';
    final String path='/books/v1/volumes/junbDwAAQBAJ';
    Uri url = Uri.https(authority, path) ;
    return http.get(url);
  }

  Future<int> returnOneAsync() async {
    await Future.delayed(const Duration(seconds: 1));
    return 1;
  }

  Future<int> returnTwoAsync() async {
    await Future.delayed(const Duration(seconds: 1));
    return 2;
  }

  Future<int> returnThreeAsync() async {
    await Future.delayed(const Duration(seconds: 1));
    return 3;
  }

  Future count() async {
    int total = 0;
    total = await returnOneAsync();
    total += await returnTwoAsync();
    total += await returnThreeAsync();
    setState(() {
      result = total.toString();
    });
  }

  Future<Error> returnError() async {
    await Future.delayed(const Duration(seconds: 1));
    throw Exception('Something terrible happened!');
  }

  Future handleError() async {
    try {
      await returnError();
    }
    catch (error) {
      setState(() {
        result = error.toString();
      });
    }
    finally {
      print('Complete');
    }
  }



}

