import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  required String label,
  bool isObscure = false,
  InputBorder? borderStyle,
  IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  Function? onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isObscure,
      enabled: isClickable,
      onTap: () {
        onTap!();
      },
      decoration: InputDecoration(
        labelText: label,
        border: borderStyle,
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(
                  suffix,
                ),
                onPressed: () {
                  suffixPressed!();
                },
              )
            : null,
        prefixIcon: Icon(
          prefix,
        ),
      ),
      validator: (value) {
        return validate(value);
      },
    );

Widget emptyTasksAlert()=>Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Icon(
        Icons.task,
        size: 100.0,
        color: Colors.grey,
      ),
      Text(
        'There is No tasks, please add tasks',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ],
  ),
);

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['id'],
                );
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updateData(
                  status: 'archived',
                  id: model['id'],
                );
              },
              icon: const Icon(
                 Icons.archive,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
    );
