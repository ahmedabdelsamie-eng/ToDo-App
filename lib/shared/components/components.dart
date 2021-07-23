import 'package:elsakhraa/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget buildTextFormField({
  @required TextEditingController controller,
  @required TextInputType textInputType,
  Function onFieldSubmit,
  Function onTap,
  Function suffixFunction,
  @required Function validator,
  @required String hintText,
  Icon prefixIcon,
  Icon suffixIcon,
  bool isPassword = false,
  bool isClickable = false,
}) =>
    Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: TextFormField(
        obscureText: isPassword,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[500]),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon != null
              ? IconButton(icon: suffixIcon, onPressed: suffixFunction)
              : null,
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black),
        validator: validator,
        onFieldSubmitted: onFieldSubmit,
        onTap: onTap,
      ),
    );

Widget buildTaskItem(Map model, BuildContext context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).delete(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text(model['time']),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    model['date'],
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.orange,
                ),
                onPressed: () {
                  AppCubit.get(context).update(status: 'done', id: model['id']);
                }),
            IconButton(
                icon: Icon(
                  Icons.archive,
                  color: Colors.black,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .update(status: 'archieved', id: model['id']);
                })
          ],
        ),
      ),
    );
