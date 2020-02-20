import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Share a Finesse';

    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class Post {
  final String eventName;
  final String location;
  final String description;
  final String duration;

  Post({this.eventName, this.location, this.description, this.duration});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      eventName: json['name'],
      location: json['location'],
      description: json['description'],
      duration: json['duration'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = eventName;
    map["location"] = location;
    map["description"] = description;
    map["duration"] = duration;

    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return Post.fromJson(json.decode(response.body));
  });
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    eventNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const CREATE_POST_URL = 'https://finesse-nation.herokuapp.com/api/food/addEvent';
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: eventNameController,
            decoration: const InputDecoration(
              labelText: "EventName",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Event Name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: "Location",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Location';
              }
              return null;
            },
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: "Description",
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Description';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () async {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Sharing Finesse')));
                  Text eventName = Text(eventNameController.text);
                  Text location = Text(locationController.text);
                  Text description = Text(descriptionController.text);

                  Post newPost = new Post(
                      eventName: eventName.data,
                      location: location.data,
                      description: description.data,
                      duration: "20");


                  await createPost(CREATE_POST_URL, body: newPost.toMap());
                  Navigator.pop(context);
                }
              },
              child: Text('SUBMIT'),
            ),
          ),
        ],
      ),
    );
  }
}
