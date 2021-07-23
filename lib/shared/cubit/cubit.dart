import 'package:bloc/bloc.dart';
import 'package:elsakhraa/modules/archieved_screen.dart';
import 'package:elsakhraa/modules/done_screen.dart';
import 'package:elsakhraa/modules/new_tasks.dart';
import 'package:elsakhraa/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  var currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  Database database;
  void ChangeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((_) => print('database and table created'))
          .catchError((error) {
        print('error');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database
        .transaction(
      (txn) => txn.rawInsert(
        'INSERT INTO  Tasks (title,time,date,status) VALUES("$title","$time","$date","new")',
      ),
    )
        .then(
      (value) {
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      },
    ).catchError((error) {
      print('error insertion${error.toString()}');
    });
  }

  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  var isBottomSheetShown = false;
  IconData icon = Icons.edit;

  void changeBottomSheetState({
    @required bool isShow,
    @required IconData fabIcon,
  }) {
    isBottomSheetShown = isShow;
    icon = fabIcon;
    emit(AppChangeBottomSheetState());
  }

  void update({@required String status, @required int id}) {
    database.rawUpdate('UPDATE Tasks SET status = ?  WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void delete({@required int id}) {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      print('deleted done');
      getDataFromDatabase(database);
      emit(AppDeleteFromDatabaseState());
    });
  }
}
