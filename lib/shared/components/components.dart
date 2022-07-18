
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  required String lable,
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
        labelText: lable,
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

Widget buildTaskItem() => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      const CircleAvatar(
        radius: 40.0,
        child: Text(
          '02:00 PM',
        ),
      ),
      const SizedBox(
        width: 20.0,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Task Title',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,

            ),
          ),
          Text(
            '19 Jul, 2022',
            style: TextStyle(
              color: Colors.grey,

            ),
          ),
        ],
      ),
    ],
  ),
);