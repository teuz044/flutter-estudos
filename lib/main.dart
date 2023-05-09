import 'package:flutter/material.dart';
import 'package:to_do_list/screens/add_task_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  AddTaskScreen(tasks: [],),
    );
  }
}

