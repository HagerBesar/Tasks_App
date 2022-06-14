
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'cubit/cubit.dart';

// Widget defaultFormField({
//   @required TextEditingController controller,
//   @required TextInputType type,
//   Function onSubmit,
//   Function onChange,
//   Function onTap,
//   bool isPassword = false,
//   @required Function validate,
//   @required String label,
//   @required IconData prefix,
//   IconData suffix,
//   Function suffixPressed,
//   bool isClickable = true,
// }) =>
//     TextFormField(
//       controller: controller,
//       keyboardType: type,
//       obscureText: isPassword,
//       enabled: isClickable,
//       onFieldSubmitted: onSubmit(),
//       onChanged: onChange(),
//       onTap: onTap(),
//       validator: validate(),
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(
//           prefix,
//         ),
//         suffixIcon: suffix != null
//             ? IconButton(
//           onPressed: suffixPressed(),
//           icon: Icon(
//             suffix,
//           ),
//         )
//             : null,
//         border: OutlineInputBorder(),
//       ),
//     );

Widget itemBuilder(Map task,context){
  TodoCubit cubit = TodoCubit.get(context);
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children: [
        CircleAvatar(
            radius: 40.0,
            child: Text('${task['time']}')),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${task["title"]}',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text('${task["date"]}',
                style: TextStyle(
                  // fontSize: 10.0,
                  color: Colors.grey,
                ),
              ),


            ],
          ),
        ),
        IconButton(
          onPressed:(){
            cubit.updateData(status: 'done', id: task['id']);
          } ,
          icon: Icon(Icons.check_circle_outline_outlined,
            color:Colors.grey,),
        ),
        IconButton(
          onPressed:(){
            cubit.updateData(status: 'archived', id: task['id']);
          } ,
          icon: Icon(Icons.archive_outlined,
            color:Colors.grey,),
        ),

      ],
    ),
  );
}

// {required List<Map> tasks}
Widget tasksBuilder(List<Map> tasks,context){
  return ConditionalBuilder(condition: tasks.length>0,
    builder: (BuildContext context) {
    return ListView.separated(
      itemBuilder:(context, index) => itemBuilder(tasks[index],context),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all( 10.0),
        child: Container(
          color: Colors.grey[300],
          width: double.infinity,
          height: 1.0,
        ),
      ),
      itemCount: tasks.length,
    );
    },
    fallback: (context){
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 100.0,
                color: Colors.grey,
              ),
              Text(
                'No Tasks Yet, Please Add Some Tasks',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );


    },

  );
}
