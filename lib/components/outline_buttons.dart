import "package:flutter/material.dart";

class RoundOutlineButton extends StatelessWidget {
  final String text;
  final onPressed;

  RoundOutlineButton({@required this.text, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Text(text, style: TextStyle(color: Theme.of(context).accentColor)),
      onPressed: onPressed,
    );
  }
}
