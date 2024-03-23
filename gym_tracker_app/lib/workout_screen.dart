import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './exercise.dart';
import './workout_list.dart';
import './days.dart';
import './day_screen.dart';


class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {

  DayList daylist = DayList(workoutDays: []);



  List<Future<Map<String, dynamic>>> futureWorkoutData = [];
  Future <Map<String, dynamic>>? workoutData;
  TextEditingController workoutController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController typeController = TextEditingController();


  dynamic tempDeletedItem;

  @override
  void initState(){
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Workout Tracker'),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )
          )
        ],

      ),
      body: _buildDaylist(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Future<Map<String, dynamic>> getWorkoutData(String name) async {
    final url = 'https://raw.githubusercontent.com/wrkout/exercises.json/master/exercises/${name}/exercise.json';
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Widget _buildDaylist() {
    return ListView.builder(
      itemBuilder: (context, index) => _buildDayTile(daylist.workoutDays[index], index),
      itemCount: daylist.workoutDays.length,
      physics: const AlwaysScrollableScrollPhysics(),

    );
  }

  Widget _buildDayTile(Workout workout, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),

      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          setState(() {
            tempDeletedItem = daylist.workoutDays[index];
            daylist.workoutDays.removeAt(index);

          });

          //deletePrefsSong(index);

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Item deleted.'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    if (tempDeletedItem != null)
                    {
                      daylist.workoutDays.insert(index, tempDeletedItem);
                      //writePref(tempDeletedItem);
                    }

                    setState(() {

                    });
                  },
                ),
              )
          );
        }

        else if (direction == DismissDirection.endToStart)
        {
          // _editDayDialog(workout, index);
        }
      },


      child: Card(
        child: ListTile(
          title: Text(daylist.workoutDays[index].workoutName),
          subtitle: Text(daylist.workoutDays[index].workoutType),
          trailing: const Text('Press to display the workout details'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => DayScreen(day: workout))
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton()
  {
    return FloatingActionButton(
        onPressed: () => _addDayDialog(context),
        child: const Icon(Icons.add)
    );
  }

  _addDayDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Add Workout...'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dayController,
                  decoration: const InputDecoration(
                      labelText: 'Enter workout name...'
                  ),
                ),
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(
                      labelText: 'Enter workout type...'
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Cancel')
              ),
              TextButton(
                  onPressed: () {
                    if (dayController.text.isNotEmpty && typeController.text.isNotEmpty) {
                      String dayName = dayController.text;
                      String type = typeController.text;

                      dayController.text = '';
                      typeController.text = '';

                      setState(() {
                        Workout newWorkout = Workout(workoutType: type, workoutName: dayName, workouts: []);
                        daylist.workoutDays.add(newWorkout);
                        //writePref(newSong);
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'))
            ],
          );
        }
    );
  }

}

