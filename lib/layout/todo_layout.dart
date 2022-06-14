import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

// ignore: must_be_immutable
class ToDoLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var taskTitleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createData(),
      child: BlocConsumer<TodoCubit, TodoStates>(
          listener: (context, state) {
            if(state is InsertDatabaseState)
            {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            var myCubit = TodoCubit.get(context);

            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(myCubit.barTitle[myCubit.currentIndex]),
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.search))
                ],
              ),
              body: myCubit.screens[myCubit.currentIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (myCubit.isButtonSheetShow) {
                    if(formKey.currentState!.validate()) {
                      myCubit.changeButtonIcon(isShow: false, icon: Icons.edit);
                      myCubit.insert(
                          title: taskTitleController.text,
                          date: dateController.text,
                          time: timeController.text);

                      taskTitleController.text='';
                      dateController.text='';
                      timeController.text='';

                     }


                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet((context) => Container(
                              color: Colors.grey[100],
                              padding: EdgeInsets.all(20.0),

                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      controller: taskTitleController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'The value is empty';
                                        }
                                        return null;
                                      },

                                      decoration: InputDecoration(
                                        labelText: 'Task Title',
                                        prefixIcon: Icon(
                                          Icons.title_sharp,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      controller: dateController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'The value is empty';
                                        }
                                        return null;
                                      },
                                      onTap: (){
                                        showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(DateTime.now().year +1)
                                        ).then((value) {
                                          dateController.text = DateFormat.yMMMMd().format(value!);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'DATE',
                                        prefixIcon: Icon(
                                          Icons.date_range,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    TextFormField(
                                      controller: timeController,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'The value is empty';
                                        }
                                        return null;
                                      },
                                      onTap: (){
                                        showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now()
                                        ).then((value) {
                                          timeController.text= value!.format(context).toString();
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Time',
                                        prefixIcon: Icon(
                                          Icons.access_time,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .closed
                        .then((value) {
                      myCubit.changeButtonIcon(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });
                    myCubit.changeButtonIcon(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(myCubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_outlined),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archived',
                  ),
                ],
                currentIndex: myCubit.currentIndex,
                onTap: (index) {
                  myCubit.changeScreen(index);
                },
              ),
            );
          }),
    );
  }
}
