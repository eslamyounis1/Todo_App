
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool isClickable =true,
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

Widget buildTaskItem(Map model) => Padding(
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
      Column(
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
    ],
  ),
);