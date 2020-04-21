import 'package:finesse_nation/Finesse.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finesse_nation/User.dart';
import 'package:finesse_nation/Network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'Comment.dart';
import 'widgets/buildFinesseCard.dart';

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
  Future<List<Comment>> comments;
  final TextEditingController _controller = TextEditingController();

  FinesseDetailsState(Finesse fin) {
    this.fin = fin;
    this.comments = Network.getComments(fin.getId());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                fin.getActive().length < 3 &&
                        !fin.isActive.contains(fin.getEmailId())
                    ? 'Ongoing'
                    : 'Inactive',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffff9900),
                ),
              ),
              fin.getDuration() != "" &&
                      (fin.getActive().length >= 3 ||
                          fin.isActive.contains(fin.getEmailId()))
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
              color: Color(0xffff9900),
            ),
          ),
          Text(
            '${mainComments.length}',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xffc47600),
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
        hintStyle: TextStyle(color: Color(0xffc47600)),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.account_circle,
            color: randColor(User.currentUser.email),
            size: 50,
          ),
        ),
        suffixIcon: IconButton(
            color: Color(0xffff9900),
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
                  color: randColor(comment.emailId),
                  size: 50,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Text(
                            comment.emailId,
                            style: TextStyle(
                              color: Color(0xffff9900),
                            ),
                          ),
                          Text(
                            " · ${timeSince(comment.postedTime)}",
                            style: TextStyle(
                              color: Color(0xffc47600),
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
          padding: EdgeInsets.only(top: 5, bottom: 5, right: 10), child: commentView);
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
              commentsHeaderSection,
              viewCommentSection,
              addCommentSection,
            ],
          ),
        ),
//        Card(
//          color: Colors.grey[850],
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

  Color randColor(String email) {
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
      backgroundColor: Color(0xff2e3032),
      textColor: Color(0xffff9900),
    );

    return;
  }
  activeList.add(User.currentUser.email);
  fin.setActive(activeList);
  Network.updateFinesse(fin);
  Fluttertoast.showToast(
    msg: "Marked as expired",
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Color(0xff2e3032),
    textColor: Color(0xffff9900),
  );
}
