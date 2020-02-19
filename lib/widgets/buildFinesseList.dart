import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/widgets/buildFinesseCard.dart';

class buildFinesseList extends StatelessWidget{
  List<Finesse> _finesses = new List();
  getFinesses() {
    
  }


  Widget build(BuildContext context) {
    return new Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Colors.lightBlue, Colors.lightGreen],
            )
        ),
        child: new Center(

            child:
            ListView.builder(
                itemBuilder: (context, i) {
                  if(i == 0){
                    getFinesses();
                  }
                  if (i.isOdd) return Divider();
                  final index = i ~/ 2;
                  if(index >= _finesses.length){
                    _finesses.addAll(_finesses.take(10));
                  }
                  return buildFinesseCard(_finesses[index]);
                })
        )
    );
  }
}