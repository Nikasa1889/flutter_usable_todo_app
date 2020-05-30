import "package:flutter/material.dart";

class FormCard extends StatelessWidget {
  final Widget child;

  FormCard({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ],
        ),
        child: this.child);
  }
}
