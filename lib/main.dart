import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:finesse_nation/addEvent.dart';
import 'package:finesse_nation/widgets/buildFinesseList.dart';
import 'LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finesse Nation',
      theme: ThemeData(
        primaryColor: Colors.black,
        canvasColor: Colors.grey[850],
      ),
      home: LoginScreen(),
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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed('/').then((_) => false);
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(FontAwesomeIcons.signOutAlt),
              color: Colors.white,
              onPressed: () => _goToLogin(context),
            ),
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEvent()),
          );
        },
//        label: Text(''),
        key: Key('add event'),
        child: Icon(
          Icons.add,
          color: Colors.grey[850],
        ),
        backgroundColor: Color(0xffff9900),
      ),
      body: BuildFinesseList(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
