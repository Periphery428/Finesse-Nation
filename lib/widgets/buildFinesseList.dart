import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/widgets/buildFinesseCard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

class BuildFinesseList extends StatefulWidget {
  BuildFinesseList({Key key}) : super(key: key);

  @override
  _FinesseListState createState() => _FinesseListState();
}

class _FinesseListState extends State<BuildFinesseList> {
  Future<List<Finesse>> _finesses = Network.fetchFinesses();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

//  Future<List<Finesse>> toFuture(var list) async {
//    return list;
//  }

  void _onRefresh() async {
//    List<Finesse> list = await Network.fetchFinesses();
    setState(() {
      _finesses = Network.fetchFinesses();
    });
//    await Future.delayed(Duration(seconds: 2));
    if (_finesses != null) {
      _refreshController.refreshCompleted();
    }
  }

//  _onLoading() async {
//    print('loading...');
//    await Future.delayed(Duration(seconds: 10));
////    _refreshController.loadComplete();
////    _finesses = fetchFinesses();
////    _refreshController.loadComplete();
//  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
//        gradient: LinearGradient(
//          begin: Alignment.topLeft,
//          end: Alignment.bottomRight,
//          colors: [Colors.lightBlue, Colors.pink],
//        ),
      ),
      child: FutureBuilder(
        future: _finesses,
        builder: (context, snapshot) {
          return snapshot.data != null
              ? listViewWidget(snapshot.data, context)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget listViewWidget(List<Finesse> _finesses, BuildContext context) {
    return Container(
      color: Colors.black,
//      decoration: BoxDecoration(
//          gradient: LinearGradient(
//        begin: Alignment.topLeft,
//        end: Alignment.bottomRight,
//        colors: [Colors.lightBlue, Colors.pink],

      child: Center(
        key: Key("refresher"),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
//          onLoading: _onLoading,
          child: ListView.builder(
              key: Key("listview"),
              itemCount: _finesses.length * 2,
              itemBuilder: (context, i) {
                _finesses = _finesses.reversed.toList();
                if (i.isOdd) return Divider();
                final index = i ~/ 2;
                return buildFinesseCard(_finesses[index], context);
              }),
        ),
      ),
    );
  }
}
