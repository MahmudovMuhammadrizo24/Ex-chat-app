import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ex_chat_app/pages/chatpage.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:ex_chat_app/service/auth.dart';
import 'package:ex_chat_app/pages/signin.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream<QuerySnapshot>? chatRoomsStream;

  // SharedPreferences dan ma'lumotlarni olish
  Future<void> getthesharedpref() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  // Boshlang'ich ma'lumotlarni yuklash
  Future<void> ontheload() async {
    await getthesharedpref();
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  // Chiqish funksiyasi
  Future<void> logOut() async {
    await AuthMethods().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  // Chat roomlar ro'yxati widgeti
  Widget ChatRoomList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return ChatRoomListTile(
                chatRoomId: ds.id,
                lastMessage: ds["lastMessage"] ?? "",
                myUsername: myUserName ?? "",
                time: ds["lastMessageSendTs"] ?? "",
              );
            },
          );
        } else {
          return const Center(child: Text("No Chat Rooms Available"));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  // ChatRoomId ni username'lar asosida yaratish
  String getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  List<Map<String, dynamic>> queryResultSet = [];
  List<Map<String, dynamic>> tempSearchStore = [];

  // Qidiruvni boshlash
  void initiateSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        queryResultSet.clear();
        tempSearchStore.clear();
        search = false;
      });
      return;
    }
    setState(() {
      search = true;
    });

    String capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        queryResultSet = docs.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        // Filtrlash
        tempSearchStore = queryResultSet
            .where(
              (element) => element['username'].startsWith(capitalizedValue),
            )
            .toList();
        setState(() {});
      });
    } else {
      tempSearchStore = queryResultSet
          .where((element) => element['username'].startsWith(capitalizedValue))
          .toList();
      setState(() {});
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF553370),

    drawer: Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF553370),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 30, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  myName ?? "User",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  myEmail ?? "",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF553370)),
            title: const Text("Profile Settings"),
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(...); // Profil sahifasiga o‘tish
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF553370)),
            title: const Text("Logout"),
            onTap: () async{
              Navigator.pop(context);
              await logOut(); 
              // logout funksiyasini shu yerda chaqiring
            },
          ),
        ],
      ),
    ),

    appBar: AppBar(
      backgroundColor: const Color(0xFF553370),
      elevation: 0,
      automaticallyImplyLeading: true,
      title: search
          ? TextField(
              onChanged: (value) => initiateSearch(value.trim()),
              decoration: const InputDecoration(
                hintText: 'Search user',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          : const Text(
              "ChatUp",
              style: TextStyle(
                color: Color(0Xffc199cd),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            search ? Icons.close : Icons.search,
            color: const Color(0Xffc199cd),
          ),
          onPressed: () {
            setState(() {
              search = !search;
              if (!search) {
                queryResultSet.clear();
                tempSearchStore.clear();
              }
            });
          },
        ),
      ],
    ),

    body: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: search
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              itemCount: tempSearchStore.length,
              itemBuilder: (context, index) {
                return buildResultCard(tempSearchStore[index]);
              },
            )
          : ChatRoomList(),
    ),
  );
}

  Widget buildResultCard(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          search = false;
        });

        String chatRoomId = getChatRoomIdbyUsername(
          myUserName!,
          data["username"],
        );

        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, data["username"]],
          "lastMessage": "",
          "lastMessageSendTs": "",
        };

        await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              name: data["Name"],
              profileurl: "", // default image
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    'assets/images/default_avatar.png',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data["username"],
                      style: const TextStyle(
                        color: Colors.black,
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
  const ChatRoomListTile({
    required this.chatRoomId,
    required this.lastMessage,
    required this.myUsername,
    required this.time,
    super.key,
  });

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    // ChatRoomId dan username'ni ajratib olish
    username = widget.chatRoomId
        .replaceAll("_", "")
        .replaceAll(widget.myUsername, "");

    var snapshot = await DatabaseMethods().getUserInfo(username.toUpperCase());
    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data() as Map<String, dynamic>;
      setState(() {
        name = data["Name"] ?? username;
        profilePicUrl = data["Photo"] ?? "";
      });
    }
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
              username: username,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.lastMessage, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.time,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
