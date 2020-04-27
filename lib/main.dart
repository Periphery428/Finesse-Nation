import 'package:flutter/material.dart';
import 'package:finesse_nation/Pages/addEvent.dart';
import 'package:finesse_nation/Pages/Settings.dart';
import 'package:finesse_nation/widgets/buildFinesseList.dart';
import 'package:finesse_nation/widgets/PopUpBox.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:finesse_nation/Pages/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Network.dart';
import 'Finesse.dart';
import 'Pages/FinessePage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

void showInSnackBar(String title, String body, String eventId, BuildContext context, Function callback) {
  _scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xffc47600),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            body,
            style: TextStyle(
              color: Color(0xffc47600),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
          label: 'VIEW', onPressed: () => callback(eventId, context)),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.getBool('activeFilter') ?? _prefs.setBool('activeFilter', true);
  _prefs.getBool('typeFilter') ?? _prefs.setBool('typeFilter', true);
  runApp(MyApp());
}

//User currentUser = User("Test", "Test", "Test");

// This is the type used by the popup menu below.
enum DotMenu { settings, about, contact }
bool _fcmAlreadySetup = false;

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
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> _activeFilter;
  Future<bool> _typeFilter;

  bool localActive;
  bool localType;

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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<void> goToEvent(String id, BuildContext context) async {
    Fluttertoast.showToast(
      msg: "Loading Finesse...",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Color(0xff2e3032),
      textColor: Color(0xffff9900),
    );
    List<Finesse> finesses = await Network.fetchFinesses();
    Finesse latest = finesses.firstWhere((finesse) => finesse.getId() == id);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FinessePage(latest)));
    setState(() {
      print('reloading');
    });
  }

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

  @override
  Widget build(BuildContext context) {
    if (!_fcmAlreadySetup) {
      _firebaseMessaging.subscribeToTopic(Network.ALL_TOPIC);
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          String id = message['data']['event_id'];
          String title = message['notification']['title'];
          String body = message['notification']['body'];
          print('recieved event id = $id');
//          Flushbar(
//            title: message['notification']['title'],
//            message: message['notification']['body'],
//            duration: Duration(seconds: 3),
//            mainButton: FlatButton(
//              onPressed: () => goToEvent(id),
//              child: Text(
//                'VIEW',
//              ),
//              textColor: Color(0xffff9900),
//            ),
//          )..show(context);
//          Scaffold.of(context).showSnackBar(
//            SnackBar(
//              content: Text(
//                'Sharing Finesse',
//                style: TextStyle(
//                  color: Color(0xffc47600),
//                ),
//              ),
//            ),
//          );
          showInSnackBar(title, body, id, context, goToEvent);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          String id = message['data']['event_id'];
          goToEvent(id, context);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          String id = message['data']['event_id'];
          goToEvent(id, context);
        },
      );
    }
    _fcmAlreadySetup = true;
    if (!kIsWeb) {
      _firebaseMessaging.requestNotificationPermissions();
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title
//          title: Text(widget.title),
          title: Hero(
            tag: 'logo',
            child: Image.asset(
              'images/logo.png',
              height: 35,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
//            IconButton(
//              icon: const Icon(FontAwesomeIcons.signOutAlt),
//              key: Key('logoutButton'),
//              color: Colors.white,
//              onPressed: () => _goToLogin(context),
//            ),
            IconButton(
              icon: Image.asset("images/baseline_filter_list_black_18dp.png",
                  key: Key("Filter"), color: Colors.white),
              onPressed: () async {
                await PopUpBox.showPopupBox(
                  context: context,
                  button: FlatButton(
                    key: Key("FilterOK"),
                    onPressed: () {
                      if (localActive != null) {
                        _setActiveFilter(localActive);
                      }
                      if (localType != null) {
                        _setTypeFilter(localType);
                      }

                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Color(0xffff9900),
                      ),
                    ),
                  ),
                  willDisplayWidget: Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 10, bottom: 30),
                            child: Text(
                              'Show inactive posts',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10, bottom: 10),
                            child: Text(
                              'Show non food posts',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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
                                      return Wrap(children: <Widget>[Text('')]);
                                    } else {
                                      return CustomSwitch(
                                        key: Key("activeFilter"),
                                        activeColor: Color(0xffff9900),
                                        value: snapshot.data,
                                        onChanged: (value) {
                                          localActive = value;
                                        },
                                      );
                                    }
                                }
                              },
                            ),
                          ),
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
                                              activeColor: Color(0xffff9900),
                                              value: snapshot.data,
                                              onChanged: (value) {
                                                localType = value;
                                              });
                                        }
                                    }
                                  })),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            PopupMenuButton<DotMenu>(
              key: Key("dropdownButton"),
              onSelected: (DotMenu result) {
                setState(() {
                  switch (result) {
                    case DotMenu.settings:
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Settings()),
                        );
                      }
                      break;
                    case DotMenu.about:
                      {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => Settings()),
//                        );
                      }
                      break;
                    case DotMenu.contact:
                      {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => Settings()),
//                        );
                      }
                      break;
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<DotMenu>>[
                const PopupMenuItem<DotMenu>(
                  key: Key("settingsButton"),
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
