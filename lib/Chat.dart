import 'package:aluminia/ChatBox.dart';
import 'package:aluminia/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream chatRooms;
  String uid;
  Auth auth = new Auth();

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: uid == snapshot.data.documents[index]['users'][1] ? snapshot.data.documents[index]['users'][0] : snapshot.data.documents[index]['users'][1],    
                    chatRoomId: snapshot.data.documents[index]["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    String me = await auth.getName(FirebaseAuth.instance.currentUser.uid);
    setState(() {
      uid = me;
    });
    auth.getUserChats(uid).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  $uid");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ChatBox(
            chatRoomId: chatRoomId,
            user: userName,
          )
        ));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 0.1 * MediaQuery.of(context).size.width),
      leading: CircleAvatar(),
      title: Text(userName),
    );
  }
}