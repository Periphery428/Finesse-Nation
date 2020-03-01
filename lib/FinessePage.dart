import 'package:finesse_nation/Finesse.dart';
import 'package:flutter/material.dart';

class FinessePage extends StatelessWidget {
  Finesse fin;
  FinessePage(Finesse fin) {
    this.fin = fin;
  }

  Widget build(BuildContext context) {
    final appTitle = fin.getTitle();

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lightBlue, Colors.pink],
            ),
          ),
          child: FinesseDetails(fin)),
    );
  }
}

// Create the details widget.
class FinesseDetails extends StatefulWidget {
  Finesse fin;
  FinesseDetails(Finesse fin) {
    this.fin = fin;
  }
  @override
  FinesseDetailsState createState() {
    return FinesseDetailsState(fin);
  }
}

// Create a corresponding State class.
class FinesseDetailsState extends State<FinesseDetails> {
  Finesse fin;
  FinesseDetailsState(Finesse fin) {
    this.fin = fin;
  }
  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        fin.getTitle(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
    Widget descriptionSection = Container(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.info,
              color: Colors.grey,
              size: 24.0,
            ),
          ),
          Flexible(
            child: Text(
              fin.getDescription(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
    Widget timeSection = Container(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.calendar_today,
              color: Colors.grey,
              size: 24.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ongoing',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '10 pizzas left' /*fin.getDuration()*/,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey
                ),
              ),
            ],
          ),
        ],
      ),
    );
    Widget locationSection = Container(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.place,
              color: Colors.grey,
              size: 24.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Siebel Center',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Room 1331' /*fin.getDuration()*/,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return ListView(
      children: [

        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                fin.getImage(),
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
              titleSection,
              descriptionSection,
              timeSection,
              locationSection,
            ],
          ),
        ),
      ],
    );
  }
}
