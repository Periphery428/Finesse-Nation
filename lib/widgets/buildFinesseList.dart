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

  void _onRefresh() async {
    setState(() {
      _finesses = Network.fetchFinesses();
    });
    if (_finesses != null) {
      _refreshController.refreshCompleted();
    }
  }


  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
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
      child: Center(
        key: Key("refresher"),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
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
