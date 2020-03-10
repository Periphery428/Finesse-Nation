import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/FinessePage.dart';
import 'package:flutter/material.dart';

Card buildFinesseCard(Finesse fin, BuildContext context) {
  return Card(
    color: Colors.white,
    child: InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinessePage(fin)),
        )
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        fin.getImage() == ""
            ? Container()
            : Image.memory(
                fin.getConvertedImage(),
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
        ListTile(
//          isThreeLine: true,
          leading: Icon(Icons.fastfood),
          title: fin.getTitle() == null
              ? Text("Null")
              : Text(
                  fin.getTitle(),
                  key: Key("title"),
                ),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                fin.getDescription() == null
//                    ? Text("Null")
//                    : Text(fin.getDescription()),
                fin.getLocation() == null ? Text("") : Text(fin.getLocation())
              ]),
          trailing: fin.getTimePosted() == null
              ? Text('')
              : Text(timeSince(fin.timePosted)),
        ),
      ]),
    ),
  );
}

String timeSince(DateTime timePosted) {
  DateTime currTime = new DateTime.now();
  Duration difference = currTime.difference(timePosted);
  int seconds = difference.inSeconds;
  int minutes = difference.inMinutes;
  int hours = difference.inHours;
  int days = difference.inDays;

  if (days < 1) {
    if (hours < 1) {
      if (minutes < 1) {
        if (seconds < 0) {
          return "";
        } else {
          return seconds.toString() + " seconds ago";
        }
      } else {
        return minutes.toString() + " minutes ago";
      }
    } else {
      return hours.toString() + " hours ago";
    }
  } else {
    return days.toString() + " days ago";
  }
}
