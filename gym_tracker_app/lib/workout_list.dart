import 'package:flutter/material.dart';
import './exercise.dart';

class Workout
{

  String workoutType;
  String workoutName;
  List<Exercise> workouts;

  Workout({this.workoutType = '', this.workoutName = '', this.workouts = const []});

}