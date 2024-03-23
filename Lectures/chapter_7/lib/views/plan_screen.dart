import '../models/data_layer.dart';
import 'package:flutter/material.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  State createState() => _PlanScreenState();
}
class _PlanScreenState extends State<PlanScreen> {

  Plan plan = Plan(name:"Graduate from AUS", tasks: []); //TS added arguments

  @override
  void initState() {
    super.initState();
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
          plan.tasks.add(Task());
        });
      },
    );}
  //------------------------------------------------
  Widget _buildList() {
    return ListView.builder(

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
      });
    }),
      title: TextFormField(
        onChanged: (text) {
          setState(() {
            //TS removed const list such that I can add to the list without creating a new one
            plan.tasks[index].description = text;
          });
        },
      ),
    );
  }

}
