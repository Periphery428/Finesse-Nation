import 'package:flutter/material.dart';
import 'package:finesse_nation/addEvent.dart';
import 'package:finesse_nation/widgets/buildFinesseList.dart';
import 'package:popup_box/popup_box.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finesse_nation/User.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.getBool('activeFilter') ?? _prefs.setBool('activeFilter', true);
  _prefs.getBool('typeFilter') ?? _prefs.setBool('typeFilter', true);
  runApp(MyApp());
}

User currentUser = new User("Blank", "Blank", "Blank");

// This is the type used by the popup menu below.
enum DotMenu { settings, about, contact }

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finesse Nation',
      theme: ThemeData(
        primaryColor: Colors.black,
        canvasColor: Colors.grey[850],
        accentColor: Color(0xffff9900),
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed('/').then((_) => false);
  }

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
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(FontAwesomeIcons.signOutAlt),
              color: Colors.white,
              onPressed: () => _goToLogin(context),
            ),
            IconButton(
              icon: Image.asset("images/baseline_filter_list_black_18dp.png",
                  key: Key("Filter"), color: Colors.white),
              onPressed: () async {
                await PopupBox.showPopupBox(
                    context: context,
                    button: MaterialButton(
                      color: Colors.blue,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          side: BorderSide(color: Colors.blue)),
                      child: Text(
                        'OK',
                        key: Key("FilterOK"),
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (localActive != null) {
                          _setActiveFilter(localActive);
                        }
                        if (localType != null) {
                          _setTypeFilter(localType);
                        }

                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
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
            PopupMenuButton<DotMenu>(
              onSelected: (DotMenu result) {
                setState(() {
                  print(result);
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<DotMenu>>[
                const PopupMenuItem<DotMenu>(
                  value: DotMenu.settings,
                  child: Text('Settings'),
                ),
                const PopupMenuItem<DotMenu>(
                  value: DotMenu.about,
                  child: Text('About'),
                ),
                const PopupMenuItem<DotMenu>(
                  value: DotMenu.contact,
                  child: Text('Contact'),
                ),
              ],
            )
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEvent()),
          );
        },
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
