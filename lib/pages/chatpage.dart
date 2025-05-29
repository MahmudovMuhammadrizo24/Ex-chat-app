import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChatPage extends StatefulWidget {
  String name, profileurl, username;
  ChatPage({
    required this.name,
    required this.profileurl,
    required this.username,
  });

  @override
  State<ChatPage> createState() => _ChatpageState();
}

class _ChatpageState extends State<ChatPage> {
  TextEditingController messagecontroller = new TextEditingController();
  String? myUserName, myProfilePic, myName, myEmail, messageId, charRoomId ;
  Stream? messageStream;
  gethtesharepref() async {
    myUserName = await SharedPreferenceHelper().getUserName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myName = await SharedPreferenceHelper().getDisplayName();
    myEmail = await SharedPreferenceHelper().getUserEmil();

    charRoomId = getRoomIdbyUserName(widget.username, myUserName!);
    setState(() {});
  }

  ontheloading() async {
    await gethtesharepref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheloading();
  }

  // utils.dart
  String getRoomIdbyUserName(String a, String b) {
    return a.compareTo(b) > 0 ? "$b\_$a" : "$a\_$b";
  }

  Widget chatMessageTle(String message)

  Widget chatMessage() {
    return StreamBuilder(
      stream:messageStream,
      builder: (context, AsyncSnapshot snapshot) {
return  snapshot.hasData? ListView.builder(
  padding: EdgeInsets.only(bottom: 90.0, top: 130),
  itemCount: snapshot.data.docs.length,
  reverse: true,
  itemBuilder: (context,index){
    DocumentSnapshot ds = snapshot.data.docs[index];
    return 
  })

    });
  }

  addMessage(bool sendClicked) {
    if (messagecontroller.text != "") {
      String message = messagecontroller.text;
      messagecontroller.text = "";

      DateTime now = DateTime.now();
      String formattedDate = DateFormat("h:mma").format(now);
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "imgUrl": myProfilePic,
      };

      messageId ??= randomAlphaNumeric(10);

      DatabaseMethods()
          .addMessage(charRoomId!, messageId!, messageInfoMap)
          .then((value) {
            Map<String, dynamic> lastMessageInfoMap = {
              "LastMessage": message,
              "LastMesageSendTs": formattedDate,
              "time": FieldValue.serverTimestamp(),
              "LastMessageSendBy": myUserName,
            };
            DatabaseMethods().updateLastMessageSend(
              charRoomId!,
              lastMessageInfoMap,
            );

            if (sendClicked) {
              messageId = null;
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      body: Container(
        margin: EdgeInsets.only(top: 60.0),

        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFFc199cd),
                ),
                SizedBox(width: 150),
                Text(
                  "Chat Up",
                  style: TextStyle(
                    color: Color(0XFFc199cd),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 50.0,
                bottom: 40.0,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.15,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 2,
                    ),
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 232, 235, 239),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Hello,How was the day?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 3,
                    ),
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 222, 236, 249),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "The day was really good?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messagecontroller,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              addMessage(true);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color(0xFFf3f3f3),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.send,
                                  color: Color.fromARGB(255, 163, 158, 158),
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
