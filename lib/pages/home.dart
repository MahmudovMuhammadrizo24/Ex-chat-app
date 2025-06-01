/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ex_chat_app/pages/chatpage.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStream;
  List queryResultSet = [];
  List tempSearchStore = [];

  @override
  void initState() {
    super.initState();
    getthesharedpref();
  }

  getthesharedpref() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmil();
    setState(() {});
  }

  ontheloading() async {
    await getthesharedpref();
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  Widget ChatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.doc.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.doc.length;
                return ChatRoomListTile(
                  chatRoomId: ds.id,
                  lastMessage: ds["lastMessage"],
                  myUsername: myUserName!,
                  time: ds["lastMessageSendTs"],
                );
              },
            )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  String getChatRoomId(String a, String b) {
    return a.codeUnitAt(0) > b.codeUnitAt(0) ? "$b\_$a" : "$a\_$b";
  }

  void initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() {
      search = true;
    });

    final capitalizedValue = value[0].toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot snapshot) {
        List tempList = [];
        for (var doc in snapshot.docs) {
          tempList.add(doc.data());
        }
        setState(() {
          queryResultSet = tempList;
        });
      });
    } else {
      List tempList = [];
      for (var user in queryResultSet) {
        if (user["username"].toLowerCase().startsWith(
          capitalizedValue.toLowerCase(),
        )) {
          tempList.add(user);
        }
      }
      setState(() {
        tempSearchStore = tempList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF553370),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20.0),
              child:
                  search &&
                          (queryResultSet.isNotEmpty ||
                              tempSearchStore.isNotEmpty)
                      ? ListView.builder(
                        itemCount: tempSearchStore.length,
                        itemBuilder:
                            (context, index) =>
                                _buildResultCard(tempSearchStore[index]),
                      )
                      : ListView(
                        children: [
                          _buildChatTile(
                            imagePath: "images/me.jpg",
                            name: "Maxmudov Muhammadrizo",
                            message: "Hello how are you?",
                            time: "9:59 PM",
                          ),
                          const SizedBox(height: 20),
                          _buildChatTile(
                            imagePath: "images/img.jpg",
                            name: "Ayush Kumar",
                            message: "Hi what is going on?",
                            time: "10:00 PM",
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Row(
        children: [
          Expanded(
            child:
                search
                    ? TextField(
                      onChanged: initiateSearch,
                      decoration: const InputDecoration(
                        hintText: 'Search user...',
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    )
                    : const Text(
                      "Chat Up",
                      style: TextStyle(
                        color: Color(0xFFc199cd),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                search = !search;
                if (!search) {
                  queryResultSet.clear();
                  tempSearchStore.clear();
                 
                }
              
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF3a2144),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                search ? Icons.close : Icons.search,
                color: const Color(0xFFc199cd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile({
    required String imagePath,
    required String name,
    required String message,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(color: Colors.black54, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(time, style: const TextStyle(color: Colors.black45, fontSize: 13)),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          search = false;
        });

        final chatRoomId = getChatRoomId(myUserName!, data["username"]);
        final chatRoomInfo = {
          "users": [myUserName, data["username"]],
        };

        await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfo);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChatPage(
                  chatRoomId: chatRoomId,
                  name: data["Name"],
                  profileurl: data["Photo"],
                  username: data["username"],
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    data["Photo"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"] ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data["username"] ?? "",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  ChatRoomListTile({
    required this.chatRoomId,
    required this.lastMessage,
    required this.myUsername,
    required this.time,
  });

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "", id = "";

  getthisUserInfo() async {
    username = widget.chatRoomId
        .replaceAll("_", "")
        .replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(
      username.toUpperCase(),
    );
    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    setState(() {});
  }

  @override
  void initState() {
    getthisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return profilePicUrl.isEmpty || name.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: ListTile(
            onTap: () {
              // Navigate to Chat Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChatPage(
                        chatRoomId: widget.chatRoomId,
                        username: username,
                        name: name,
                        profileurl: profilePicUrl,
                      ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(profilePicUrl),
              radius: 28,
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.lastMessage),
            trailing: Text(widget.time),
          ),
        );
  }
}*/
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ex_chat_app/pages/chatpage.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  List queryResultSet = [];
  List tempSearchStore = [];

  Stream? chatRoomsStream;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmil();
    chatRoomsStream = DatabaseMethods().getChatRooms(myUserName!);
    setState(() {});
  }

  String getChatRoomId(String a, String b) {
    return a.codeUnitAt(0) > b.codeUnitAt(0) ? "$b\_$a" : "$a\_$b";
  }

  void initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    setState(() {
      search = true;
    });

    final capitalizedValue = value[0].toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot snapshot) {
        List tempList = [];
        for (var doc in snapshot.docs) {
          tempList.add(doc.data());
        }
        setState(() {
          queryResultSet = tempList;
        });
      });
    } else {
      List tempList = [];
      for (var user in queryResultSet) {
        if (user["username"]
            .toLowerCase()
            .startsWith(capitalizedValue.toLowerCase())) {
          tempList.add(user);
        }
      }
      setState(() {
        tempSearchStore = tempList;
      });
    }
  }

  void navigateToChat(Map<String, dynamic> userData) async {
    final chatRoomId = getChatRoomId(myUserName!, userData["username"]);
    final chatRoomInfo = {
      "users": [myUserName, userData["username"]],
    };

    await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfo);

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          name: userData["Name"],
          profileurl: userData["Photo"],
          username: userData["username"],
        ),
      ),
    );

    // agar xabar yuborilgan bo‘lsa, chatRoomsStream-ni yangilaymiz
    if (result == true) {
      setState(() {
        chatRoomsStream = DatabaseMethods().getChatRooms(myUserName!);
      });
    }
  }

  Widget _buildChatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(child: Text("No recent chats"));
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data.docs[index];
            List users = doc["users"];
            String otherUsername =
                users.firstWhere((u) => u != myUserName, orElse: () => "");

            return FutureBuilder(
              future: DatabaseMethods().getUserByUsername(otherUsername),
              builder: (context, AsyncSnapshot userSnap) {
                if (!userSnap.hasData || userSnap.data == null) {
                  return SizedBox.shrink();
                }

                var userData = userSnap.data!.docs.first.data();
                return GestureDetector(
                  onTap: () => navigateToChat(userData),
                  child: _buildUserCard(
                    name: userData["Name"],
                    username: userData["username"],
                    photo: userData["Photo"],
                    lastMessage: doc["LastMessage"] ?? "",
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUserCard({
    required String name,
    required String username,
    required String photo,
    required String lastMessage,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  photo,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "@$username",
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  if (lastMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        "Last: $lastMessage",
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: search
                ? TextField(
                    onChanged: initiateSearch,
                    decoration: const InputDecoration(
                      hintText: 'Search user...',
                      hintStyle: TextStyle(color: Colors.black54, fontSize: 18),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  )
                : const Text(
                    "Chat Up",
                    style: TextStyle(
                      color: Color(0xFFc199cd),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                search = !search;
                if (!search) {
                  queryResultSet.clear();
                  tempSearchStore.clear();
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF3a2144),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                search ? Icons.close : Icons.search,
                color: const Color(0xFFc199cd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF553370),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20.0),
              child: search && tempSearchStore.isNotEmpty
                  ? ListView.builder(
                      itemCount: tempSearchStore.length,
                      itemBuilder: (context, index) {
                        final data = tempSearchStore[index];
                        return GestureDetector(
                          onTap: () => navigateToChat(data),
                          child: _buildUserCard(
                            name: data["Name"],
                            username: data["username"],
                            photo: data["Photo"],
                            lastMessage: "",
                          ),
                        );
                      },
                    )
                  : _buildChatRoomList(),
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ex_chat_app/pages/chatpage.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStream;

  getthesharedpref() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  Widget ChatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    print(ds.id);
                    return ChatRoomListTile(
                        chatRoomId: ds.id,
                        lastMessage: ds["lastMessage"],
                        myUsername: myUserName!,
                        time: ds["lastMessageSendTs"]);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['username'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF553370),
        body: Container(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search
                    ? Expanded(
                        child: TextField(
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search User',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500)),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ))
                    : Text(
                        "ChatUp",
                        style: TextStyle(
                            color: Color(0Xffc199cd),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                GestureDetector(
                  onTap: () {
                    search = true;
                    setState(() {});
                  },
                  child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color(0xFF3a2144),
                          borderRadius: BorderRadius.circular(20)),
                      child: search
                          ? GestureDetector(
                              onTap: () {
                                search = false;
                                setState(() {});
                              },
                              child: Icon(
                                Icons.close,
                                color: Color(0Xffc199cd),
                              ),
                            )
                          : Icon(
                              Icons.search,
                              color: Color(0Xffc199cd),
                            )),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            width: MediaQuery.of(context).size.width,
            height: search
                ? MediaQuery.of(context).size.height / 1.19
                : MediaQuery.of(context).size.height / 1.15,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              children: [
                search
                    ? ListView(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        primary: false,
                        shrinkWrap: true,
                        children: tempSearchStore.map((element) {
                          return buildResultCard(element);
                        }).toList())
                    : ChatRoomList(),
              ],
            ),
          ),
        ])));
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        search = false;

        var chatRoomId = getChatRoomIdbyUsername(myUserName!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, data["username"]],
        };
        await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    name: data["Name"],
                    profileurl: data["Photo"],
                    username: data["username"])));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      data["Photo"],
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      data["username"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  ChatRoomListTile(
      {required this.chatRoomId,
      required this.lastMessage,
      required this.myUsername,
      required this.time});

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "", id = "";

  getthisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
    print(username);
    QuerySnapshot querySnapshot =
        await DatabaseMethods().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    setState(() {});
  }

  @override
  void initState() {
    getthisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    name: name,
                    profileurl: profilePicUrl,
                    username: username)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePicUrl == ""
                ? CircularProgressIndicator()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      profilePicUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    )),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  username,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    widget.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              widget.time,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
