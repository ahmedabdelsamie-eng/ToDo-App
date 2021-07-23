import 'package:elsakhraa/shared/components/components.dart';
import 'package:elsakhraa/shared/cubit/cubit.dart';
import 'package:elsakhraa/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return AppCubit.get(context).newTasks.length > 0
              ? ListView.separated(
                  itemBuilder: (ctx, index) =>
                      buildTaskItem(cubit.newTasks[index], context),
                  separatorBuilder: (ctx, index) => Padding(
                        padding: const EdgeInsetsDirectional.only(start: 30),
                        child: Divider(
                          height: 2,
                        ),
                      ),
                  itemCount: cubit.newTasks.length)
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu,
                        size: 80,
                        color: Colors.grey,
                      ),
                      Text(
                        'لم يتم إضافة مهام بعد',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                );
        });
  }
}
