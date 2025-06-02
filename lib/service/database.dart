import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ex_chat_app/service/shared_pref.dart';

class DatabaseMethods {
  // Foydalanuvchi ma'lumotlarini Firestore 'users' kolleksiyasiga qo'shadi yoki yangilaydi
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  // Berilgan email bo'yicha foydalanuvchini qidiradi
  Future<QuerySnapshot> getUserbyemail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("E-mail", isEqualTo: email)
        .get();
  }

  // Foydalanuvchilarni SearchKey maydoniga qarab qidiradi (birinchi harf katta bo'lishi kerak)
  Future<QuerySnapshot> Search(String username) async {
    String searchKey = username.substring(0, 1).toUpperCase();
    return await FirebaseFirestore.instance
        .collection("users")
        .where("SearchKey", isEqualTo: searchKey)
        .get();
  }

  // Chat room yaratadi yoki mavjud bo'lsa, mavjudini qaytaradi
  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      return true;
    } else {
      return await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  // Chatroomga xabar qo'shadi
  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  // So'nggi yuborilgan xabar ma'lumotlarini chatroom hujjatiga yangilaydi
  Future updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  // Berilgan chatRoomId ga tegishli xabarlar oqimini (stream) olish
  Future<Stream<QuerySnapshot>> getChatRoomMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  // Berilgan username bo'yicha foydalanuvchi ma'lumotlarini olish
  Future<QuerySnapshot> getUserInfo(String username) async {
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .where("username", isEqualTo: username)
          .get();
    } catch (e) {
      print("Error fetching user info: $e");
      rethrow;
    }
  }

  // Hozirgi foydalanuvchining chat roomlarini oqim (stream) sifatida olish
  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = await SharedPreferenceHelper().getUserName();
    print("Current username: $myUsername");
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("time", descending: true)
        .where("users", arrayContains: myUsername)
        .snapshots();
  }
}

