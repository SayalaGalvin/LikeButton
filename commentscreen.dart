import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen(document, this.postId);
  @override
  _CommentScreenState createState() => _CommentScreenState(
      postId: this.postId,
  );
}

class _CommentScreenState extends State<CommentScreen> {
  final String postId;


  final TextEditingController _commentController = TextEditingController();

  _CommentScreenState({this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: buildPage(),
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        Expanded(
          child:
          buildComments(),
        ),
        Divider(),
        ListTile(
          title: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Write a comment...'),
            onFieldSubmitted: addComment,
          ),
          trailing: FlatButton(onPressed: (){addComment(_commentController.text);},child: Text("Post"),),
        ),

      ],
    );

  }


  Widget buildComments() {
    return FutureBuilder<List<Comment>>(
        future: getComments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data,
          );
        });
  }

  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];

    QuerySnapshot data = await Firestore.instance
        .collection("/posts")
        .document(postId)
        .collection("comments")
        .getDocuments();
    data.documents.forEach((DocumentSnapshot doc) {
      comments.add(Comment.fromDocument(doc));
    });

    return comments;
  }

  addComment(String comment) {
    _commentController.clear();
    Firestore.instance
        .collection("/posts")
        .document(postId)
        .collection("comments")
        .add({
      "username": 'Kusal',
        "comment": comment,
        "timestamp": DateTime.now().toString(),
       "userid": '5',
    });
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String comment;
  final String timestamp;

  Comment(
      {this.username,
        this.userId,
        this.comment,
        this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      username: document['username'],
      userId: document['userId'],
      comment: document["comment"],
      timestamp: document["timestamp"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          subtitle: Text(username),
        ),
        Divider(),
      ],
    );
  }
}
