import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushBarMessage {
  void showflushBarMessage(BuildContext context, String message, status,
      {duration: 3, position: 'bottom', overlayBlurVal: 0.0, titleVal: ''}) {
    // check the title is exist or not
    if (titleVal == '') {
      titleVal = null;
    }

    // check the position of the flush bar
    var positionVal = FlushbarPosition.BOTTOM;
    if (position == 'top') {
      positionVal = FlushbarPosition.TOP;
    }

    // color of flush bar
    Color bgColor = Colors.green;
    if (status == 'success') {
      bgColor = Colors.green;
    }

    if (status == 'error') {
      bgColor = Colors.red;
    }

    if (status == 'info') {
      bgColor = Color(0XFF9380D5);
    }

    if (message != null) {
      Flushbar(
        title: titleVal,
        message: message,
        flushbarPosition: positionVal,
        routeBlur: overlayBlurVal,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
        messageText: Text(
          message.toString(),
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
        ),
        mainButton: (status == 'error')
            ? FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.white,
                  height: 25,
                  child: Center(
                    child: Text(
                      "  Close  ",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              )
            : null,
        backgroundColor: bgColor,
        duration: (status == 'error') ? null : Duration(seconds: duration),
        isDismissible: true,
      )..show(context);
    }
  }
}
