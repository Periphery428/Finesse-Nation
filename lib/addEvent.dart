import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:camera/camera.dart';
import 'package:finesse_nation/main.dart';
import 'package:finesse_nation/User.dart';
import 'package:finesse_nation/cameraPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';

var firstCamera = CameraDescription();

class AddEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Share a Finesse';

    setupCamera();
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      backgroundColor: Colors.grey[850],
      body: MyCustomForm(),
    );
  }
}

void setupCamera() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  firstCamera = cameras.first;
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  final eventNameController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final typeController = TextEditingController();
  String _type = "Food";
  String image = "images/photo_camera_black_288x288.png";
  final _formKey = GlobalKey<FormState>();
  File _image;
  double width = 600;
  double height = 240;
  dynamic _pickImageError;
  String _retrieveDataError;

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: width, maxHeight: height);

    setState(() {
      _image = image;
    });
    @override
    void dispose() {
      // Clean up the controller when the widget is disposed.
      eventNameController.dispose();
      locationController.dispose();
      descriptionController.dispose();
      durationController.dispose();
      typeController.dispose();
      super.dispose();
    }

    navigateAndDisplaySelection(BuildContext context) async {
      // Navigator.push returns a Future that completes after calling
      // Navigator.pop on the Selection Screen.
      String newImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TakePictureScreen(
                camera: firstCamera,
              ),
        ),
      );
//    if (newImage != null) {
//      setState(() {
//        image = newImage;
//      });
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      _image = await ImagePicker.pickImage(
          source: source,
          maxWidth: width,
          maxHeight: height,
          imageQuality: null);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

//  Future<void> _displayPickImageDialog(
//      BuildContext context, OnPickImageCallback onPick) async {
//
//    onPick(width, height, quality);
//  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    var render;
//    if (image == "images/photo_camera_black_288x288.png") {
//      render = Icon(
//        Icons.camera_alt,
//        size: 100,
//        color: Color(0xffFF9900),
//      );
//    } else {
//      render = Image.file(
//        File(image),
//        width: 600,
//        height: 240,
//      );
//    }
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[850],
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                key: Key('name'),
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: eventNameController,
                decoration: const InputDecoration(
                  labelText: "Title*",
                  labelStyle: TextStyle(
                    color: Color(0xffFF9900),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter an Event Name';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: Key('location'),
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location*",
                  labelStyle: TextStyle(
                    color: Color(0xffFF9900),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a Location';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: Key('description'),
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(
                    color: Color(0xffFF9900),
                  ),
                ),
                validator: (value) {
                  return null;
                },
              ),
              TextFormField(
                key: Key('duration'),
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: "Duration",
                  labelStyle: TextStyle(
                    color: Color(0xffFF9900),
                  ),
                ),
                validator: (value) {
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Type",
                  style: TextStyle(
                    color: Color(0xffFF9900),
                    fontSize: 16,
                  ),
                ),
              ),
              new DropdownButton<String>(
//                hint: Text("Select an event type"),
                style: TextStyle(color: Colors.red),
                items: <String>['Food', 'Other'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
                value: _type,
                onChanged: (newValue) {
                  setState(() {
                    _type = newValue;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  "Image",
                  style: TextStyle(
                    color: Color(0xffFF9900),
                    fontSize: 16,
                  ),
                ),
              ),
              Row(children: [
                FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                  heroTag: 'image0',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.photo_library),
                ),
                FloatingActionButton(
                  key: Key("cameraButton"),
                  onPressed: () {
                    getImage();
                  },
                  heroTag: 'camera_pick',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.camera_alt),
                )
              ]),
              Material(
                child: InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Container(
                    color: Colors.grey[850],
//                  height: 150.0,
//                    alignment: Alignment.center,
                    child: Center(
                      child: _image == null ? Container() : Image.file(_image),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ButtonTheme(
                    minWidth: 100,
                    height: 50,
                    child: RaisedButton(
                      key: Key('submit'),
                      color: Color(0xffFF9900),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('Sharing Finesse',
                                  style: TextStyle(color: Color(0xffc47600)))));
                          Text eventName = Text(eventNameController.text);
                          Text location = Text(locationController.text);
                          Text description = Text(descriptionController.text);
                          Text duration = Text(durationController.text);
                          DateTime currTime = new DateTime.now();

                          String imageString;
                          if (_image == null) {
                            imageString = '';
                          } else {
                            imageString =
                                base64Encode(_image.readAsBytesSync());
                          }

                          Finesse newFinesse = Finesse.finesseAdd(
                            eventName.data,
                            description.data,
                            imageString,
                            location.data,
                            duration.data,
                            _type,
                            currTime,
                          );
                          await Network.addFinesse(newFinesse);
                          FirebaseMessaging().unsubscribeFromTopic('all');
                          await Network.sendToAll(
                              newFinesse.getTitle(), newFinesse.getLocation());
                          if (User.currentUser.notifications) {
                            FirebaseMessaging().subscribeToTopic('all');
                          }
                          Navigator.removeRouteBelow(
                              context, ModalRoute.of(context));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MyHomePage(title: 'Finesse Nation')));
                        }
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(color: Colors.grey[850]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef void OnPickImageCallback(double maxWidth, double maxHeight,
    int quality);
