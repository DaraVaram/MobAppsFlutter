import './task.dart';

//TS removed const and final such that we can add directly to the list and modify tasks without creating new ones
class Plan {
  String name;
  List<Task> tasks;
  Plan({this.name = '', required this.tasks });
}
