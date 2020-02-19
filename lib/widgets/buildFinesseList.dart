import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/widgets/buildFinesseCard.dart';
import 'package:http/http.dart' as http;

class buildFinesseList extends StatelessWidget{
  Future<List<Finesse>> fetchFinesse() async{
    final response = await http.get('http://finesse-nation.herokuapp.com/api/food/getEvents');
    var responseJson;

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      var responseJson = data.map<Finesse>((json) => Finesse.fromJson(json)).toList();
      return responseJson;
    }else{
      throw Exception('Failed to load finesses');
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetchFinesse(),
        builder: (context, snapshot){
          return snapshot.data != null ?
              listViewWidget(snapshot.data)
              :Center(child: CircularProgressIndicator());
        },
      )
    );
  }

  Widget listViewWidget(List<Finesse> _finesses) {
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