import 'dart:math';
import 'package:flutter/material.dart';
import 'package:finesse_nation/addEvent.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finesse Nation',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Rahbert'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _scale = 1;

//  Color _color = Color.fromRGBO(0, 255, 0, 0.1);
  void _incrementCounter() {
    var rng = new Random();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun theflect the updated valuese build method below
      // so that the display can r. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      var old = _scale;
      while (_scale == old) {
        _scale = rng.nextInt(9) + 1.0; //rng.nextDouble() * 9 + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addEvent()),
          );
        },
        label: Text('Add Event'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      body: _buildFinesseList(),

      // This trailing comma makes auto-formatting nicer for build methods.
      );
    }

    List<Finesse> _finesses = new List();
    getFinesses() {
      _finesses.add(Finesse("Fin 1 Title", "Fin 1 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 2 Title", "Fin 2 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 3 Title", "Fin 3 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 4 Title", "Fin 4 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 5 Title", "Fin 5 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 6 Title", "Fin 6 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 7 Title", "Fin 7 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 8 Title", "Fin 8 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 9 Title", "Fin 9 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 10 Title", "Fin 10 Duration", "images/rahbert.png"));
      _finesses.add(Finesse("Fin 11 Title", "Fin 11 Duration", "images/rahbert.png"));
    }


    Widget _buildFinesseList() {
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
                return _buildFinesseCard(_finesses[index]);
              })
        )
      );
    }


  Widget _buildFinesseCard(Finesse fin) {
    return Card(
      color: Colors.lime[200],
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Image.asset(fin.getImage()),
             ListTile(
              leading: Icon(Icons.accessible_forward),
              title: Text(fin.getTitle()),
              subtitle: Text(fin.getBody()),
            ),
          ]),
    );
  }
}


class Finesse{
  String title;
  String body;
  String duration;
  String image;

  Finesse(String title, String body, String img){
    this.title = title;
    this.body = body;
    this.image = img;
  }

  String getImage(){
    return image;
  }

  String getBody(){
    return body;
  }

  String getTitle(){
    return image;
  }
}

