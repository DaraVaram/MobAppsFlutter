import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Exercise{
  static int exerciseID = 1;
late int id;

String exerciseName;
String exerciseForce;
String Equipment;
String Category;
int reps;
int sets;


  Exercise({this.exerciseName = '', this.exerciseForce = '', this.Equipment = '', this.Category = '', this.reps = 0, this.sets = 0})
  {
    id = exerciseID++;
  }

}