import 'package:flutter/material.dart';
import 'package:finesse_nation/Finesse.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

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
  String _type = "FOOD";
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: eventNameController,
            decoration: const InputDecoration(
              labelText: "EventName*",
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
              labelText: "Location*",
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
              return null;
            },
          ),
          TextFormField(
            controller: durationController,
            decoration: const InputDecoration(
              labelText: "Duration",
            ),
            validator: (value) {
              return null;
            },
          ),
          new DropdownButton<String>(
//        hint: Text("Select an event type")
            items: <String>['FOOD', 'OTHER'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            value: _type,
            onChanged: (newValue) {
              setState(() {
                _type = newValue;
              });
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
                  Text duration = Text(durationController.text);
                  Finesse newFinesse = new Finesse(
                    eventName.data,
                    description.data,
                    "image",
                    location.data,
                    duration.data,
                    _type,
                  );
                  await newFinesse.addFinesse();
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
