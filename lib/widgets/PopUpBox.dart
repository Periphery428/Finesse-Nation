import 'package:flutter/material.dart';

class PopUpBox {
  static Future showPopupBox(
      {BuildContext context, Widget willDisplayWidget, Widget button}) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Filter',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.grey[850],
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
