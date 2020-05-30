import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class RoundContainedButton extends StatelessWidget {
  final onPressed;
  final String text;
  final bool primary;

  const RoundContainedButton(
      {@required this.text, @required this.onPressed, @required this.primary});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      fillColor: primary
          ? Theme.of(context).accentColor
          : Theme.of(context).buttonColor,
      child: Text(text,
          style: primary
              ? Theme.of(context).accentTextTheme.button
              : Theme.of(context).textTheme.button),
    );
  }
}
