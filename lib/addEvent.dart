import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Share Free Stuff';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
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
  final String image;

  Post({this.eventName, this.location, this.image});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      eventName: json['eventName'],
      location: json['location'],
      image: json['image'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["eventName"] = eventName;
    map["location"] = location;
    map["image"] = image;

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
  final imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    eventNameController.dispose();
    locationController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CREATE_POST_URL = 'https://ptsv2.com/t/yofb8-1581474248/post';
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: eventNameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Event Name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: locationController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Location';
              }
              return null;
            },
          ),
          TextFormField(
            controller: imageController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Image';
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
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  Text eventName = Text(eventNameController.text);
                  Text location = Text(locationController.text);
                  Text image = Text(imageController.text);

                  Post newPost = new Post(
                      eventName: eventName.data,
                      location: location.data,
                      image: image.data);

                  Post p =
                      await createPost(CREATE_POST_URL, body: newPost.toMap());
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
