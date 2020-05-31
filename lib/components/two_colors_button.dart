import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class TwoColorsButton extends StatelessWidget {
  final onPressed;
  final String text;
  final bool primary;

  const TwoColorsButton(
      {@required this.text, @required this.onPressed, @required this.primary});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: primary
          ? Theme.of(context).accentColor
          : Theme.of(context).buttonColor,
      child: Text(text,
          style: primary
              ? Theme.of(context).accentTextTheme.button
              : Theme.of(context).textTheme.button),
    );
  }
}
