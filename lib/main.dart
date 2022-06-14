import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/todo_layout.dart';
import 'package:todo_app/shared/cubit/bloc_observer.dart';

void main() {

  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:ToDoLayout(),
    );
  }
}

