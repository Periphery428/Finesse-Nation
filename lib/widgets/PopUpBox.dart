import 'package:flutter/material.dart';
import 'package:finesse_nation/Styles.dart';

/// Displays a [Dialog] containing filtering options.
class PopUpBox {
  static Future showPopupBox(
      {BuildContext context,
      Widget willDisplayWidget,
      Widget button,
      String title = "Filter"}) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Styles.darkGrey,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                willDisplayWidget,
              ],
            ),
            actions: <Widget>[button],
          );
        });
  }
}
