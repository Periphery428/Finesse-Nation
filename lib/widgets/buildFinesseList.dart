import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/widgets/buildFinesseCard.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class buildFinesseList extends StatelessWidget{
  Future<List<Finesse>> _finesses;
  Future<List<Finesse>> fetchFinesses() async{
    final response = await http.get('http://finesse-nation.herokuapp.com/api/food/getEvents');
    var responseJson;

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      var responseJson = data
          .map<Finesse>((json) => Finesse.fromJson(json))
          .toList();
      return responseJson;
    }else{
      throw Exception('Failed to load finesses');
    }
  }

  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

   _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _finesses = fetchFinesses();
    _refreshController.loadComplete();
  }


  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetchFinesses(),
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
              end: Alignment.bottomRight,
              colors: [Colors.lightBlue, Colors.pink],
            )
        ),
        child: new Center(
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                    itemCount: _finesses.length*2,
                    itemBuilder: (context, i) {
                      _finesses =_finesses.reversed.toList();
                      if (i.isOdd) return Divider();
                      final index = i ~/ 2;
                      return buildFinesseCard(_finesses[index]);
                    })
            )
        )
    );
  }
}
