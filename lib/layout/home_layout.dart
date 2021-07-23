import 'package:elsakhraa/shared/components/components.dart';
import 'package:elsakhraa/shared/cubit/cubit.dart';
import 'package:elsakhraa/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatelessWidget {
  Database database;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<FormState> _formKey = GlobalKey();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
            listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        }, builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    SystemNavigator.pop();
                  }),
              title: Text(
                'أچندة أعمال',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: state is! AppGetDatabaseLoadingState
                ? cubit.screens[cubit.currentIndex]
                : Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (_formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    titleController.text = '';
                    timeController.text = '';
                    dateController.text = '';
                  }
                } else {
                  _scaffoldKey.currentState
                      .showBottomSheet(
                          (context) => Container(
                                color: Colors.teal,
                                padding: EdgeInsets.all(20),
                                height: 240,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      buildTextFormField(
                                          controller: titleController,
                                          textInputType: TextInputType.text,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'يتوجب عليك إضافة البيانات';
                                            }
                                            return null;
                                          },
                                          hintText: 'إسم المشروع',
                                          prefixIcon: Icon(Icons.title),
                                          onTap: () {}),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      buildTextFormField(
                                          controller: timeController,
                                          textInputType: TextInputType.datetime,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'يتوجب عليك إضافة توقيت';
                                            }
                                            return null;
                                          },
                                          hintText: 'توقيت المشروع',
                                          prefixIcon:
                                              Icon(Icons.watch_later_outlined),
                                          onTap: () {
                                            showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) {
                                              timeController.text =
                                                  value.format(context);
                                            });
                                          }),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      buildTextFormField(
                                          controller: dateController,
                                          textInputType: TextInputType.datetime,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'يتوجب عليك إضافة تاريخ';
                                            }
                                            return null;
                                          },
                                          hintText: 'تاريخ المشروع',
                                          prefixIcon:
                                              Icon(Icons.calendar_today),
                                          onTap: () {
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime.parse(
                                                        '2022-01-01'))
                                                .then((value) {
                                              dateController.text =
                                                  DateFormat.yMMMEd()
                                                      .format(value);
                                              ;
                                            });
                                            ;
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                          elevation: 20)
                      .closed
                      .then((value) {
                    titleController.text = '';
                    timeController.text = '';
                    dateController.text = '';
                    cubit.changeBottomSheetState(
                        isShow: false, fabIcon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(
                      isShow: true, fabIcon: Icons.add);
                }
              },
              child: Icon(cubit.icon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 30,
              backgroundColor: Colors.grey[200],
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu), label: "قيد التنفيذ"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: "تم التنفيذ"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "أرشيف"),
              ],
            ),
          );
        }));
  }
}
