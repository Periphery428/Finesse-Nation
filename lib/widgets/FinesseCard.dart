import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Pages/FinessePage.dart';
import 'package:flutter/material.dart';
import 'package:finesse_nation/Util.dart';
import 'package:finesse_nation/Styles.dart';

/// Returns a [Card] displaying the [Finesse] details.
Card buildFinesseCard(Finesse fin, BuildContext context) {
  return Card(
    color: Styles.darkGrey,
    child: InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FinessePage(fin)),
        )
      },
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Hero(
          tag: fin.eventId,
          child: fin.image == ""
              ? Container()
              : Image.memory(
                  fin.convertedImage,
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
        ),
        ListTile(
          leading: Icon(
            fin.category == "Food" ? Icons.fastfood : Icons.help,
            color: Styles.darkOrange,
          ),
          title: fin.eventTitle == null
              ? Text("Null")
              : Text(
                  fin.eventTitle,
                  key: Key("title"),
                  style: TextStyle(
                    fontSize: 16,
                    color: Styles.brightOrange,
                  ),
                ),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                fin.location == null
                    ? Text("")
                    : Text(
                        fin.location,
                        style: TextStyle(color: Styles.darkOrange),
                      )
              ]),
          trailing: fin.postedTime == null
              ? Text('')
              : Text(
                  Util.timeSince(fin.postedTime),
                  style: TextStyle(color: Styles.darkOrange),
                ),
        ),
      ]),
    ),
  );
}
