import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_screen.dart';
import 'package:todo_app/modules/done_screen.dart';
import 'package:todo_app/modules/tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());

  static TodoCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchivedScreen()];

  List<String> barTitle = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeScreen(index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  bool isButtonSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeButtonIcon({required isShow, required icon}) {
    isButtonSheetShow = isShow;
    fabIcon = icon;
    emit(ChangeIconButtonState());
  }

  ////////////////
  // Database

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createData() {
    openDatabase(
      'ToDo.db',
      version: 1,
      onCreate: (database, version) {
        database.execute(
                "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT) "
         ).then((value) {
           print('Table created');
         }).catchError((onError) {
           print('Create Error is : ${onError.toString()}');
         });
      },
      onOpen: (database){
        getData(database);


      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }


  insert({required title,required date,required time})async
  {
     await database.transaction((txn){
      return txn.rawInsert('INSERT INTO tasks (title, date, time, status) VALUES ("$title", "$date", "$time","new")'
          ).then((value) {
            print('insert $value done');
            emit(InsertDatabaseState());
            getData(database);

          }).catchError((onError) {
            print('Insert Error is : ${onError.toString()}');
          });

    });
  }

  void getData(database){
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetDatabaseLoadingState());

    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archivedTasks.add(element);
      });
      print('newTasks : $newTasks');
      print('doneTasks : $doneTasks');
      print('archivedTasks :$archivedTasks');

      emit(GetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getData(database);
      emit(UpdateDatabaseState());
    });
  }

}
