import 'package:finesse_nation/Finesse.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finesse_nation/User.dart';
import 'package:finesse_nation/Network.dart';

enum DotMenu {markEnded}

class FinessePage extends StatelessWidget {
  final Finesse fin;

  FinessePage(this.fin);

  Widget build(BuildContext context) {
    final title = fin.getTitle();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton<DotMenu>(
            onSelected: (DotMenu result) {
              markAsEnded(fin);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<DotMenu>>[
              const PopupMenuItem<DotMenu>(
                value: DotMenu.markEnded,
                child: Text('Mark as ended'),
              ),
            ],
          )
        ],
      ),
      body: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.topLeft,
//              end: Alignment.bottomRight,
//              colors: [Colors.lightBlue, Colors.pink],
//            ),
//          ),
          child: FinesseDetails(fin)),
      backgroundColor: Colors.black,
    );
  }
}

// Create the details widget.
class FinesseDetails extends StatefulWidget {
  final Finesse fin;

  FinesseDetails(this.fin);

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
    Widget imageSection = InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullImage(
            fin,
          ),
        ),
      ),
      child: Hero(
        tag: fin.getId(),
        child: Image.memory(
          fin.getConvertedImage(),
          width: 600,
          height: 240,
          fit: BoxFit.cover,
        ),
      ),
    );
    Widget titleSection = Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        fin.getTitle(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color(0xffff9900),
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
              color: Color(0xffc47600),
              size: 24.0,
            ),
          ),
          Flexible(
            child: Text(
              fin.getDescription(),
              style: TextStyle(
                fontSize: 16,
                color: Color(0xffff9900),
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
              color: Color(0xffc47600),
              size: 24.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fin.getActive() == true ? 'Ongoing' : 'Inactive',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffff9900),
                ),
              ),
              fin.getDuration() != ""
                  ? Text("Duration: ${fin.getDuration()}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffc47600),
                      ))
                  : Container(),
            ],
          ),
        ],
      ),
    );

    Widget userSection = Container(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.account_circle,
              color: Color(0xffc47600),
              size: 24.0,
            ),
          ),
          Text(
            "Posted by: ",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xffff9900),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fin.getEmailId(),
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffff9900),
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
              color: Color(0xffc47600),
              size: 24.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Text(
                  fin.getLocation(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffff9900),
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => launch(
                    'https://www.google.com/maps/search/${fin.getLocation()}'),
              ),
            ],
          ),
        ],
      ),
    );
    return ListView(
      children: [
        Card(
          color: Colors.grey[850],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fin.getImage() != "" ? imageSection : Container(),
              titleSection,
              locationSection,
              fin.getDescription() != "" ? descriptionSection : Container(),
              timeSection,
              userSection,
            ],
          ),
        ),
      ],
    );
  }
}

class FullImage extends StatelessWidget {
  final Finesse fin;

  FullImage(this.fin);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: fin.getId(),
            child: Image.memory(
              fin.getConvertedImage(),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

markAsEnded(Finesse fin){
  List activeList = fin.getActive();
  print(activeList);
  activeList.add(User.currentUser.email);
  print(activeList);
  fin.setActive(activeList);
  Network.updateFinesse(fin);
}

