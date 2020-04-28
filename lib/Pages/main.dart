import 'package:flutter/material.dart';
import 'package:finesse_nation/Pages/addEventPage.dart';
import 'package:finesse_nation/Pages/SettingsPage.dart';
import 'package:finesse_nation/widgets/buildFinesseList.dart';
import 'package:finesse_nation/widgets/PopUpBox.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:finesse_nation/Pages/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Pages/FinessePage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:finesse_nation/Styles.dart';

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
        canvasColor: Styles.darkGrey,
        accentColor: Styles.brightOrange,
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

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

  Future<void> goToEvent(String id) async {
    Fluttertoast.showToast(
      msg: "Loading Finesse...",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Styles.darkGrey,
      textColor: Styles.brightOrange,
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
    _firebaseMessaging.subscribeToTopic(Network.ALL_TOPIC);
    if (!_fcmAlreadySetup) {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          String id = message['data']['event_id'];
          print('recieved event id = $id');
          Flushbar(
            title: message['notification']['title'],
            message: message['notification']['body'],
            duration: Duration(seconds: 3),
            mainButton: FlatButton(
              onPressed: () => goToEvent(id),
              child: Text(
                'VIEW',
              ),
              textColor: Styles.brightOrange,
            ),)..show(context);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          String id = message['data']['event_id'];
          goToEvent(id);
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          String id = message['data']['event_id'];
          goToEvent(id);
        },
      );
    }
    _fcmAlreadySetup = true;
    if (!kIsWeb) {
      _firebaseMessaging.requestNotificationPermissions();
    }
  }

  Future<void> showFilterMenu() async {
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
            color: Styles.brightOrange,
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
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                            activeColor: Styles.brightOrange,
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
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator();
                          default:
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Wrap(children: <Widget>[Text('')]);
                            } else {
                              return CustomSwitch(
                                  key: Key("typeFilter"),
                                  activeColor: Styles.brightOrange,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title
          title: Hero(
            tag: 'logo',
            child: Image.asset(
              'images/logo.png',
              height: 35,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Image.asset("images/baseline_filter_list_black_18dp.png",
                  key: Key("Filter"), color: Colors.white),
              onPressed: () async {
                showFilterMenu();
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
          color: Styles.darkGrey,
        ),
        backgroundColor: Styles.brightOrange,
      ),
      body: BuildFinesseList(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
