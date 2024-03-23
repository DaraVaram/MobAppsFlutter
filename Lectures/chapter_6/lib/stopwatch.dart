import 'package:flutter/material.dart';
import 'dart:async';
import './platform_alert.dart';


class StopWatch extends StatefulWidget {
  final String name;
  final String email;
  const StopWatch({super.key, required this.name, required this.email});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {

  int milliseconds = 0;
  late Timer timer;
  bool isTicking = false;
  bool isPaused = false;
  final laps = <int>[];
  final itemHeight = 60.0;
  final scrollController = ScrollController();

  @override
  void initState() {
    //do initializations here
    super.initState();
    // timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer time) {
    if (mounted) {
      setState(() {
        milliseconds += 100;
      }
      );
    }
  }



  String _secondsText (int milliseconds){
    final seconds = milliseconds / 1000;
    return (seconds == 1) ? '$seconds second' : '$seconds seconds';
  }

  void _lap(){
    setState(() {
      laps.add(milliseconds);
      milliseconds = 0;
    });

    scrollController.animateTo(itemHeight * laps.length, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);

  }

  // Widget _buildLapDisplay() {
  //   return ListView(
  //     children: [
  //       for (int milliseconds in laps)
  //         ListTile(
  //           title: Text (_secondsText (milliseconds)),
  //         )
  //     ],
  //   );
  // }

  Widget _buildLapDisplay() {
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,
        itemCount: laps.length,
        itemBuilder: (context, index) {
          final milliseconds = laps [index] ;
          return ListTile (
            contentPadding:
            const EdgeInsets.symmetric(horizontal : 20),
            title: Text ('Lap ${index + 1} '),
            trailing: Text (_secondsText
              (milliseconds)),
          );
        },
      ),
    );
  }



  @override
  void dispose() {
    timer.cancel();
    super.dispose();
    scrollController.dispose();
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Lap ${laps.length + 1}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          Text(
            '${_secondsText(milliseconds)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),

          const SizedBox (height: 20),
          _buildControls()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay())
        ],
      ),

    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: isTicking ? MaterialStateProperty.all<Color>(Colors.green) : MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),

          onPressed: isTicking ? null : _startTimer,
          child: const Text('Start'),
        ),
        const SizedBox (width: 20),
        TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
            onPressed: isTicking ? _lap : null,
            child: const Text(
              'Lap',
            )
        ),
        const SizedBox (width: 20),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: (isTicking && !isPaused) ? _pauseTimer : _stopTimer,
          child: Text(
            (isPaused) ? 'Stop' : 'Pause',
          ),
        ),
      ],
    );
  }

  void _startTimer(){
    if (!isTicking) {
      setState(() {
        isTicking = true;
        if (!isPaused) {
          milliseconds = 0;
          laps.clear();
        }
        isPaused = false;

        timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);
      }
      );
    }
  }


  void _pauseTimer() {
    if (isTicking) {
      timer.cancel();

      setState(() {
        isTicking = false;
        isPaused = true; // Indicate that the timer is paused, not stopped.
      }
      );
    }
  }

  void _stopTimer(){
    timer.cancel();
    setState(() {
      isTicking = false;
      isPaused = false;
    });
    final totalRuntime = laps.fold(milliseconds, (total, lap) => total + lap);
    final alert = PlatformAlert(
      title: 'Run Completed!',
      message: 'Total Run Time is ${_secondsText(totalRuntime)}.',
    );
    alert.show(context);

  }

}