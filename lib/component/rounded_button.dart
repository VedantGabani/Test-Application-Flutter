import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color colour;
  final String title;
  final Function onPressed;
  final double padding;
  final double textSize;
  RoundedButton(
      {this.colour,
      this.title,
      @required this.onPressed,
      this.padding,
      this.textSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: (padding == null) ? 16.0 : padding),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(25.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 45.0,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: (textSize == null) ? 14.0 : textSize,
            ),
          ),
        ),
      ),
    );
  }
}
