import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

void notifySuccess(BuildContext context,
    {String title, @required String message}) {
  FlushbarHelper.createSuccess(
    title: title,
    message: message,
    duration: Duration(seconds: 3),
  ).show(context);
}

void notifyLoading(BuildContext context,
    {String title, @required String message}) {
  FlushbarHelper.createLoading(
    title: title,
    message: message,
    linearProgressIndicator: LinearProgressIndicator(),
    duration: Duration(seconds: 3),
  ).show(context);
}

void notifyError(BuildContext context,
    {String title, @required String message}) {
  Flushbar flush;
  flush = Flushbar<bool>(
    title: title,
    message: message,
    icon: Icon(
      Icons.warning,
      size: 28.0,
      color: Colors.red[300],
    ),
    leftBarIndicatorColor: Colors.red[300],
    duration: Duration(seconds: 15),
    mainButton: FlatButton(
      onPressed: () {
        flush.dismiss(true); // result = true
      },
      child: Text(
        "Dismiss",
        style: TextStyle(color: Colors.amber),
      ),
    ),
  );
  flush.show(context);
}

void notifyInfo(BuildContext context,
    {String title, @required String message}) {
  FlushbarHelper.createInformation(
    title: title,
    message: message,
    duration: Duration(seconds: 3),
  ).show(context);
}
