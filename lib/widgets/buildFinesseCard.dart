import 'package:finesse_nation/Finesse.dart';
import 'package:flutter/material.dart';

Card buildFinesseCard(Finesse fin) {
  return Card(
    color: Colors.white,
    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      fin.getImage() == null ? Text("") : Text(fin.get_Id()\),
      ListTile(
        leading: Icon(Icons.accessible_forward),
        title: fin.getTitle() == null ? Text("Null") : Text(fin.getTitle()),
        subtitle: fin.getDescription() == null
            ? Text("Null")
            : Text(fin.getDescription()),
      ),
    ]),
  );
}
