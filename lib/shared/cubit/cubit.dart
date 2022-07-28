import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled3/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget?> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  late Database database;
  List<Map> tasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
        )
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(value);
          emit(AppGetDatabaseState());
        });
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

   insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
   await database.transaction((txn) {
      return txn.rawInsert(
        'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")',
      ).then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(value);
          emit(AppGetDatabaseState());
        });
      }).catchError((error) {
        print('error when inserting ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
