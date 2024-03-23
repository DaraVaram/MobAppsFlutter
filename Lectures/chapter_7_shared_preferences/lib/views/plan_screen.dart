import 'dart:async';
import '../models/data_layer.dart';
import 'package:flutter/material.dart';
//flutter pub add shared_preferences
import 'package:shared_preferences/shared_preferences.dart'; // TS

class PlanScreen extends StatefulWidget
{
  PlanScreen({super.key});
  @override
  State createState() {
    return _PlanScreenState();
  }
}
class _PlanScreenState extends State<PlanScreen>
{
  Plan plan = Plan(name:"Graduate from AUS", tasks: []); //TS added arguments

  @override
  void initState() {
    super.initState();
    ts_readPreference().then((_){setState(() {});}); //TS read previous tasks
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${plan.name}'),),
      body: _buildList(),
      floatingActionButton: _buildAddTaskButton(),
    );
  }

  Widget _buildAddTaskButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        setState(() {
          //TS removed const list such that I can add to the list without creating a new one
          plan.tasks.add(Task(description: 'Add task here...'));
        });
      },
    );}
  //------------------------------------------------
  Widget _buildList() {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: plan.tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(plan.tasks[index], index),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
  //------------------------------------------------
  Widget _buildTaskTile(Task task, int index) {
    return ListTile(
        leading: Checkbox(
        value: task.complete,
        onChanged: (selected) {
        setState(() {
          //TS removed const list such that I can add to the list without creating a new one
         plan.tasks[index].complete = selected!;
         ts_writePreference(plan.tasks[index]);
        });
    }),
      title: TextFormField(
        initialValue: task.description,
        onChanged: (text) {
          setState(() {
            //TS removed const list such that I can add to the list without creating a new one
            plan.tasks[index].description = text;
            ts_writePreference(plan.tasks[index]);//Fix this: as it gets called with every character change....
          });
        },
      ),
    );
  }
  //TS sharedPref---------------------------------------------------------------
  Future ts_writePreference(task) async
  {
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    await prefs.setString('${task.id}',
              '${task.complete?1:0}_${task.description}');
  }
  //TS: read projects and tasks from shared Preferences
  Future ts_readPreference() async{ //not async anymore as prefs is opened in main widget
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var t_id = 1;
    //loop for the tasks
    while (true){
      var line = prefs.getString('${t_id}') ?? "";
      if (line.isEmpty){
        break;
      }else {
        var complete=false;
        if (line.split('_')[0] == "1")
          complete = true;
        plan.tasks.add(Task(complete: complete, description: line.split('_')[1]));
        print('CMP354: key: ${t_id} | values: $complete ${line.split('_')[1]}');
        t_id++;
      }
    }
  }//---------------------------------------------------------------------------
}
