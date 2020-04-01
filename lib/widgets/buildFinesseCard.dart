import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/FinessePage.dart';
import 'package:flutter/material.dart';

Card buildFinesseCard(Finesse fin, BuildContext context) {
  return Card(
    color: Colors.grey[850],
    child: InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinessePage(fin)),
        )
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Hero(
          tag: fin.getId(),
          child: fin.getImage() == ""
              ? Container()
              : Image.memory(
                  fin.getConvertedImage(),
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
        ),
        ListTile(
//          isThreeLine: true,
          leading: Icon(
            fin.getCategory() == "Food" ? Icons.fastfood : Icons.help,
            color: Color(0xffc47600),
          ),
          title: fin.getTitle() == null
              ? Text("Null")
              : Text(
                  fin.getTitle(),
                  key: Key("title"),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffff9900),
                  ),
                ),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
//                fin.getDescription() == null
//                    ? Text("Null")
//                    : Text(fin.getDescription()),
                fin.getLocation() == null
                    ? Text("")
                    : Text(
                        fin.getLocation(),
                        style: TextStyle(color: Color(0xffc47600)),
                      )
              ]),
          trailing: fin.getPostedTime() == null
              ? Text('')
              : Text(
                  timeSince(fin.postedTime),
                  style: TextStyle(color: Color(0xffc47600)),
                ),
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
          if (seconds == 1) {
            return seconds.toString() + "second ago";
          } else {
            return seconds.toString() + " seconds ago";
          }
        }
      } else {
        if (minutes == 1) {
          return minutes.toString() + "minute ago";
        } else {
          return minutes.toString() + " minutes ago";
        }
      }
    } else {
      if (hours == 1) {
        return hours.toString() + " hour ago";
      } else {
        return hours.toString() + " hours ago";
      }
    }
  } else {
    if (days == 1) {
      return days.toString() + " day ago";
    } else {
      return days.toString() + " days ago";
    }
  }
}
