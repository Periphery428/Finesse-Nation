import 'package:finesse_nation/Finesse.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finesse_nation/User.dart';
import 'package:finesse_nation/Network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import '../Comment.dart';
import '../Util.dart';
import '../Styles.dart';

enum DotMenu { markEnded }
bool _commentIsEmpty;
List<Comment> mainComments;

class FinessePage extends StatelessWidget {
  final Finesse fin;

  FinessePage(this.fin);

  Widget build(BuildContext context) {
    _commentIsEmpty = true;
    final title = fin.getTitle();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton<DotMenu>(
            key: Key("threeDotButton"),
            onSelected: (DotMenu result) {
              markAsEnded(fin);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<DotMenu>>[
              const PopupMenuItem<DotMenu>(
                key: Key("markAsEndedButton"),
                value: DotMenu.markEnded,
                child: Text('Mark as expired'),
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
  Future<List<Comment>> comments;
  final TextEditingController _controller = TextEditingController();

  FinesseDetailsState(Finesse fin) {
    this.fin = fin;
    this.comments = Network.getComments(fin.getId());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: <Comment>[],
      future: comments,
      builder: (context, snapshot) {
        return snapshot.data != null
            ? mainCard(snapshot.data, context)
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget mainCard(List<Comment> comments, BuildContext context) {
    mainComments = comments;
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
          color: Styles.brightOrange,
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
              color: Styles.darkOrange,
              size: 24.0,
            ),
          ),
          Flexible(
            child: Text(
              fin.getDescription(),
              style: TextStyle(
                fontSize: 16,
                color: Styles.brightOrange,
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
              color: Styles.darkOrange,
              size: 24.0,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fin.getActive().length < 3 &&
                        !fin.isActive.contains(fin.getEmailId())
                    ? 'Ongoing'
                    : 'Inactive',
                style: TextStyle(
                  fontSize: 16,
                  color: Styles.brightOrange,
                ),
              ),
              fin.getDuration() != "" &&
                      (fin.getActive().length < 3 &&
                          !fin.isActive.contains(fin.getEmailId()))
                  ? Text("Duration: ${fin.getDuration()}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Styles.darkOrange,
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
              color: Styles.darkOrange,
              size: 24.0,
            ),
          ),
          Text(
            "Posted by: ",
            style: TextStyle(
              fontSize: 16,
              color: Styles.brightOrange,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fin.getEmailId(),
                style: TextStyle(
                  fontSize: 16,
                  color: Styles.brightOrange,
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
              color: Styles.darkOrange,
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
                    color: Styles.brightOrange,
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

    Widget commentsHeaderSection = Padding(
      padding: EdgeInsets.only(
        left: 12,
        bottom: 10,
      ),
      child: Row(
        children: [
          Text(
            'Comments  ',
            style: TextStyle(
              fontSize: 16,
              color: Styles.brightOrange,
            ),
          ),
          Text(
            '${mainComments.length}',
            style: TextStyle(
              fontSize: 15,
              color: Styles.darkOrange,
            ),
          ),
        ],
      ),
    );

    Widget addCommentSection = TextFormField(
      controller: _controller,
      autovalidate: true,
      validator: (comment) {
//        if (comment.isEmpty) {
//          return 'Comment cannot be empty';
//        }
//        return null;
        bool isEmpty = comment.isEmpty;
        if (isEmpty != _commentIsEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _commentIsEmpty = isEmpty;
            });
          });
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Add a comment...',
        hintStyle: TextStyle(color: Styles.darkOrange),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.account_circle,
            color: getColor(User.currentUser.email),
            size: 45,
          ),
        ),
        suffixIcon: IconButton(
            color: Styles.brightOrange,
            disabledColor: Colors.grey[500],
            icon: Icon(
              Icons.send,
            ),
            onPressed: (_commentIsEmpty)
                ? null
                : () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    String comment = _controller.value.text;
                    Comment newComment = Comment.post(comment);
                    setState(() => mainComments.add(newComment));
                    Network.addComment(newComment, fin.getId());
                    _controller.clear();
                  }),
      ),
      style: TextStyle(color: Colors.grey[100]),
      onFieldSubmitted: (comment) {
        if (comment.isNotEmpty) {
          Comment newComment = Comment.post(comment);
          setState(() => mainComments.add(newComment));
          Network.addComment(newComment, fin.getId());
          _controller.clear();
        }
      },
    );

    Widget getCommentView(Comment comment) {
      Widget commentView = Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.account_circle,
                  color: getColor(comment.emailId),
                  size: 45,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 1),
                      child: Row(
                        children: [
                          Text(
                            comment.emailId,
                            style: TextStyle(
                              color: Styles.brightOrange,
                            ),
                          ),
                          Text(
                            " · ${Util.timeSince(comment.postedDateTime)}",
                            style: TextStyle(
                              color: Styles.darkOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      comment.comment,
                      style: TextStyle(
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
//          Divider(thickness: 0.5,color: Colors.black,)
        ],
      );
      commentView = Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
          right: 10,
        ),
        child: commentView,
      );
      return commentView;
    }

    List<Widget> commentsView =
        mainComments.map((comment) => getCommentView(comment)).toList();

    Widget viewCommentSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: commentsView,
    );

    return ListView(
      children: [
        Card(
          color: Styles.darkGrey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              fin.getImage() != "" ? imageSection : Container(),
              titleSection,
              locationSection,
              fin.getDescription() != "" ? descriptionSection : Container(),
              timeSection,
              userSection,
              commentsHeaderSection,
              viewCommentSection,
              addCommentSection,
            ],
          ),
        ),
//        Card(
//          color: Styles.darkGrey,
//          child: Column(
//            children: [
//              addCommentSection,
//              viewCommentSection,
//            ],
//          ),
//        ),
      ],
    );
  }

  Color getColor(String email) {
    int min = 0xff000000;
    int max = 0xffffffff;
    int seed = email.codeUnits.fold(0, (i, j) => i + j);
    int val = min + Random(seed).nextInt(max - min + 1);
    return Color(val);
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

markAsEnded(Finesse fin) {
  List activeList = fin.getActive();
  if (activeList.contains(User.currentUser.email)) {
    Fluttertoast.showToast(
      msg: "Already marked as expired",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Styles.darkGrey,
      textColor: Styles.brightOrange,
    );

    return;
  }
  activeList.add(User.currentUser.email);
  fin.setActive(activeList);
  Network.updateFinesse(fin);
  Fluttertoast.showToast(
    msg: "Marked as expired",
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Styles.darkGrey,
    textColor: Styles.brightOrange,
  );
}
