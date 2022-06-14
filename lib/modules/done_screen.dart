

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class DoneScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context,  state) {
        TodoCubit cubit = TodoCubit.get(context);
        return tasksBuilder(cubit.doneTasks,context);
      },

    );
  }
}
