import 'package:flutter/material.dart';
import 'package:finesse_nation/Finesse.dart';

Card buildFinesseCard(Finesse fin) {
  return Card(
    color: Colors.white,
    child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Image.asset(fin.getImage()),
      ListTile(
        leading: Icon(Icons.accessible_forward),
        title: Text(fin.getTitle()),
        subtitle: Text(fin.getBody()),
      ),
    ]),
  );
}
