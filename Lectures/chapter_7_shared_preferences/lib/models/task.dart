
class Task {
  static int ts_id = 1; //TS: for auto inc plan id
  late int id;
  String description;
  bool complete;

  Task({this.complete = false, required this.description }){
    id = ts_id++;
  }

}