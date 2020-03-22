import 'package:flutter/material.dart';
import 'package:finesse_nation/addEvent.dart';
import 'package:finesse_nation/widgets/buildFinesseList.dart';
import 'package:popup_box/popup_box.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
//  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
// This is the type used by the popup menu below.
enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finesse Nation',
      theme: ThemeData(
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Finesse Nation'),
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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _activeFilter;
  Future<bool> _typeFilter;

  bool localActive;
  bool localType;

  @override
  void initState() {
    super.initState();
    _activeFilter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('activeFilter') ?? true);
    });
    _typeFilter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool('typeFilter') ?? true);
    });
  }

  Future<void> _setActiveFilter(val) async {
    final SharedPreferences prefs = await _prefs;
    final bool activeFilter = val;

    setState(() {
      _activeFilter =
          prefs.setBool("activeFilter", activeFilter).then((bool success) {
            return activeFilter;
          });
    });
  }

  Future<void> _setTypeFilter(val) async {
    final SharedPreferences prefs = await _prefs;
    final bool typeFilter = val;

    setState(() {
      _typeFilter =
          prefs.setBool("typeFilter", typeFilter).then((bool success) {
            return typeFilter;
          });
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
        // the App.build method, and use it to set our appbar title
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Image.asset("images/baseline_filter_list_black_18dp.png",
                  color: Colors.white),
              onPressed: () async {
                await PopupBox.showPopupBox(
                    context: context,
                    button: MaterialButton(
                      color: Colors.blue,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          side: BorderSide(color: Colors.blue)),
                      child: Text(
                        'Ok',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (localActive != null) {
                          _setActiveFilter(localActive);
                        }
                        if (localType != null) {
                          _setTypeFilter(localType);
                        }
                        Navigator.of(context)
                            .pop(); //TODO: this will break after adding an event.
                      },
                    ),
                    willDisplayWidget: Column(children: <Widget>[
                      Wrap(alignment: WrapAlignment.center, children: <Widget>[
                        Text(
                          'Filters',
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ]),
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                  padding:
                                  EdgeInsets.only(right: 10, bottom: 30),
                                  child: Text(
                                    'Show inactive posts',
                                  )),
                              Padding(
                                  padding:
                                  EdgeInsets.only(right: 10, bottom: 10),
                                  child: Text(
                                    'Show non food posts',
                                  )),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 10, bottom: 10),
                                child: FutureBuilder<bool>(
                                    future: _activeFilter,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool> snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return const CircularProgressIndicator();
                                        default:
                                          if (snapshot.hasError) {
                                            print(snapshot.error);
                                            return Wrap(
                                                children: <Widget>[Text('')]);
                                          } else {
                                            return CustomSwitch(
                                                key: Key("activeFilter"),
                                                activeColor: Colors.pinkAccent,
                                                value: snapshot.data,
                                                onChanged: (value) {
                                                  localActive = value;
                                                });
                                          }
                                      }
                                    })),
                            Padding(
                                padding: EdgeInsets.only(right: 10, bottom: 10),
                                child: FutureBuilder<bool>(
                                    future: _typeFilter,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool> snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return const CircularProgressIndicator();
                                        default:
                                          if (snapshot.hasError) {
                                            print(snapshot.error);
                                            return Wrap(
                                                children: <Widget>[Text('')]);
                                          } else {
                                            return CustomSwitch(
                                                key: Key("typeFilter"),
                                                activeColor: Colors.pinkAccent,
                                                value: snapshot.data,
                                                onChanged: (value) {
                                                  localType = value;
                                                });
                                          }
                                      }
                                    })),
                          ],
                        ),
                      ])
                    ]));
              },
            ),
            PopupMenuButton<WhyFarther>(
              onSelected: (WhyFarther result) {
                setState(() {
                  print(result);
                });
              },
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<WhyFarther>>[
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.harder,
                  child: Text('Settings'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.smarter,
                  child: Text('About'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.selfStarter,
                  child: Text('Contact'),
                ),
              ],
            )
          ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEvent()),
          );
        },
        label: Text('Add Event'),
        key: Key('add event'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      body: BuildFinesseList(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
