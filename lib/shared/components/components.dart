
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
