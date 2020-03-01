import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/widgets/buildFinesseCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuildFinesseList extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.pink],
          ),
        ),
        child: FutureBuilder(
          future: Network.fetchFinesses(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? listViewWidget(snapshot.data, context)
                : Center(child: CircularProgressIndicator());
          },
        ));
  }

  Widget listViewWidget(List<Finesse> _finesses, BuildContext context) {
    return new Container(
        child: new Center(
            child: ListView.builder(
                itemCount: _finesses.length * 2,
                itemBuilder: (context, i) {
                  _finesses = _finesses.reversed.toList();
                  if (i.isOdd) return Divider();
                  final index = i ~/ 2;
                  return buildFinesseCard(_finesses[index], context);
                })));
  }
}
