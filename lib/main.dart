import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/shared/bloc_observer.dart';

import 'layout/home_layout.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
