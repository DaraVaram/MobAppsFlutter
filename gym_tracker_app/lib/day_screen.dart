import 'package:flutter/material.dart';
import './days.dart';
import './workout_list.dart';
import './exercise.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class DayScreen extends StatefulWidget {

  final Workout day;
  const DayScreen({super.key, required this.day});



  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {

  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController exerciseSetController = TextEditingController();
  TextEditingController exerciseRepController = TextEditingController();

  Future <Map<String, dynamic>> ? exerciseData;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day.workoutName),
      ),
      body: _bodyBuilder(),
      floatingActionButton: _buildExerciseFloatingActionButton(),
    );
  }

  GridView _bodyBuilder() {
    return GridView.builder(
      itemCount: widget.day.workouts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of items in each row
        mainAxisSpacing: 2.0, // spacing between rows
        crossAxisSpacing: 2.0, // spacing between columns
      ),
      padding: EdgeInsets.all(20.0),
      itemBuilder: (context, index) {
        return Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.day.workouts[index].exerciseName),
                const SizedBox(height: 8.0,),
                Text('Sets: ' + widget.day.workouts[index].sets.toString()),
                Text('Reps: ' + widget.day.workouts[index].reps.toString()),
                Text('Category: ' + widget.day.workouts[index].Category.toString()),
                Text('Equipment: ' + widget.day.workouts[index].Equipment.toString()),
                Text('Force: ' + widget.day.workouts[index].exerciseForce.toString()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseFloatingActionButton(){
    return FloatingActionButton(
      onPressed: () {
        _addExerciseDialog(context);
      },
      child: Icon(Icons.add),
    );
  }

  _addExerciseDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return FutureBuilder(
            future: exerciseData,
            builder: (context, snapshot) {
              return AlertDialog(
                title: const Text('Add Exercise...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: exerciseNameController,
                      decoration: const InputDecoration(
                          labelText: 'Enter exercise name...'
                      ),
                    ),
                    TextField(
                      controller: exerciseSetController,
                      decoration: const InputDecoration(
                          labelText: 'Enter number of sets...'
                      ),
                    ),
                    TextField(
                      controller: exerciseRepController,
                      decoration: const InputDecoration(
                          labelText: 'Enter number of reps per set...'
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
                      onPressed: () async {
                        if (exerciseNameController.text.isNotEmpty && exerciseSetController.text.isNotEmpty && exerciseRepController.text.isNotEmpty) {
                          String exerciseName = exerciseNameController.text;
                          int exerciseSets = int.parse(exerciseSetController.text);
                          int exerciseReps = int.parse(exerciseRepController.text);

                          exerciseNameController.text = '';
                          exerciseSetController.text = '';
                          exerciseRepController.text = '';




                          var ExerciseData = await getWorkoutData(exerciseName);

                          var category = ExerciseData['category'] ?? 'Unknown';
                          var equipment = ExerciseData['equipment'] ?? 'Unknown';
                          var force = ExerciseData['force'] ?? 'Unknown';






                          setState(() {
                            Exercise newExercise = Exercise(exerciseName: exerciseName, sets: exerciseSets, reps: exerciseReps, Category: category, exerciseForce: force, Equipment: equipment);
                            widget.day.workouts.add(newExercise);
                            //writePref(newSong);
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Add'))
                ],

              );
            },
          );
        }
    );
  }

  Future<Map<String, dynamic>> getWorkoutData(String name) async {
    final url = 'https://raw.githubusercontent.com/wrkout/exercises.json/master/exercises/${name}/exercise.json';
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Future writePrefExercises(Exercise exercise) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${exercise.id}', '${exercise.exerciseName}|${exercise.exerciseForce}|${exercise.Category}|${exercise.Equipment}|${exercise.reps.toString()}|${exercise.sets.toString()}');
  }

  Future deletePrefsExercises(Exercise exercise) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      exercise.exerciseName = '';
      exercise.exerciseForce = '';
      exercise.Equipment = '';
      exercise.Category = '';
      exercise.reps = 0;
      exercise.sets = 0;
    }
    );
  }

}
