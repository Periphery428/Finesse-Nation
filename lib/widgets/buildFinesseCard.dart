import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/FinessePage.dart';
import 'package:flutter/material.dart';

Card buildFinesseCard(Finesse fin, BuildContext context) {
  return Card(
    color: Colors.white,
    child: InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinessePage(fin)),
        )
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        fin.getImage() == null ? Text("Null") : Text(fin.getImage()),
        ListTile(
          leading: Icon(Icons.accessible_forward),
          title: fin.getTitle() == null ? Text("Null") : Text(fin.getTitle()),
          subtitle: fin.getDescription() == null
              ? Text("Null")
              : Text(fin.getDescription()),
        ),
      ]),
    ),
  );
}
