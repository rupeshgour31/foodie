import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonName;
  final Key key;
  final decoration;
  final double btnWidth;
  final double btnHeight;
  final Color color;
  final Color btnColor;
  final Color borderColor;
  final Color textColor;

  Button({
    this.buttonName,
    this.onPressed,
    this.decoration,
    this.btnWidth,
    this.btnHeight,
    this.btnColor,
    this.borderColor,
    this.textColor,
    this.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Container(
        height: btnHeight ?? 43.0,
        width: btnWidth,
        decoration: BoxDecoration(
          color: btnColor ?? Colors.transparent,
          borderRadius: decoration ?? BorderRadius.circular(2.0),
        ),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: decoration ?? BorderRadius.circular(2.0),
            side: BorderSide(color: borderColor ?? Colors.transparent),
          ),
          key: key,
          elevation: 3.0,
          color: color,
          child: Text(
            buttonName,
            style: TextStyle(
              inherit: true,
              color: textColor ?? Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w400,
              fontSize: screenSize <= 350 ? 15.0 : 16.0,
              letterSpacing: 0.3,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
