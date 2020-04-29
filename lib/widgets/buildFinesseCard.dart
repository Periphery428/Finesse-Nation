import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Pages/FinessePage.dart';
import 'package:flutter/material.dart';
import 'package:finesse_nation/Util.dart';
import 'package:finesse_nation/Styles.dart';

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
            color: Styles.darkOrange,
          ),
          title: fin.getTitle() == null
              ? Text("Null")
              : Text(
                  fin.getTitle(),
                  key: Key("title"),
                  style: TextStyle(
                    fontSize: 16,
                    color: Styles.brightOrange,
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
                        style: TextStyle(color: Styles.darkOrange),
                      )
              ]),
          trailing: fin.getPostedTime() == null
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
