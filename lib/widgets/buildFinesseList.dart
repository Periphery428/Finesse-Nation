import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/widgets/buildFinesseCard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class buildFinesseList extends StatefulWidget {
  buildFinesseList({Key key}) : super(key: key);

  @override
  _FinesseListState createState() => new _FinesseListState();
}

class _FinesseListState extends State<buildFinesseList>{
  Future<List<Finesse>> _finesses;

  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  void _onRefresh() async{
//    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _finesses = Network.fetchFinesses();
      _refreshController.refreshCompleted();
    });
  }

   _onLoading() async {
//    await Future.delayed(Duration(milliseconds: 1000));
//    _refreshController.loadComplete();
//    _finesses = fetchFinesses();
//    _refreshController.loadComplete();
  }


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
      ),
    );
  }

  Widget listViewWidget(List<Finesse> _finesses, BuildContext context) {
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
                      return buildFinesseCard(_finesses[index], context);
                    })
            )
        )
    );
  }
}
