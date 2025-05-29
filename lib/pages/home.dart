import 'package:cloud_firestore/cloud_firestore.dart';
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
              child: search && (queryResultSet.isNotEmpty || tempSearchStore.isNotEmpty)
                  ? ListView.builder(
                      itemCount: tempSearchStore.length,
                      itemBuilder: (context, index) =>
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
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          time,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 13,
          ),
        ),
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
            builder: (context) => ChatPage(
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


/*
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF553370),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search
                    ? Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search User',
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const Text(
                        "Chat Up",
                        style: TextStyle(
                          color: Color(0xFFc199cd),
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      search = !search;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3a2144),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.search, color: Color(0xFFc199cd)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  buildChatTile(
                    imagePath: "images/me.jpg",
                    name: "Maxmudov Muhammadrizo",
                    message: "Hello how are you?",
                    time: "9:59 PM",
                  ),
                  const SizedBox(height: 20),
                  buildChatTile(
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

  Widget buildChatTile({
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
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          time,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 13.0,
          ),
        ),
      ],
    );
  }
}*/
