import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled3/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:untitled3/modules/done_tasks/done_tasks_screen.dart';

import '../modules/new_tasks/new_tasks_screen.dart';
import '../shared/components/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
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

  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple,
                Colors.red,
              ],
            ),
          ),
        ),
        title: Text(
          titles[currentIndex],
        ),
        centerTitle: true,
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertDatabase(
                title: titleController.text,
                time: timeController.text,
                date: dateController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (context) => Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultFormField(
                        controller: titleController,
                        type: TextInputType.text,
                        lable: 'Task Title',
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'title must not be empty!';
                          }
                          return null;
                        },
                        prefix: Icons.title,
                        borderStyle: const OutlineInputBorder(),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: timeController,
                        type: TextInputType.datetime,
                        lable: 'Task Time',
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            timeController.text =
                                value!.format(context).toString();
                          });
                        },
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'time must not be empty!';
                          }
                          return null;
                        },
                        prefix: Icons.watch_later_outlined,
                        borderStyle: const OutlineInputBorder(),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                        controller: dateController,
                        type: TextInputType.datetime,
                        lable: 'Task Date',
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-08-18'),
                          ).then((value) {
                            dateController.text =
                                DateFormat.yMMMd().format(value!);
                          });
                        },
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'date must not be empty!';
                          }
                          return null;
                        },
                        prefix: Icons.calendar_month,
                        borderStyle: const OutlineInputBorder(),
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 20.0,
            ).closed.then((value){
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return 'Eslam Younis';
  }

  void createDatabase() async {
    database = await openDatabase(
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
        print('database opened');
      },
    );
  }

  Future insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    return database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('error when inserting ${error.toString()}');
      });
    });
  }
}
