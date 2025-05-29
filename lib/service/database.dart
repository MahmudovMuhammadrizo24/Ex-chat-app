import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Foydalanuvchi ma'lumotlarini qo‘shadi
  Future<void> addUserDetails(
    Map<String, dynamic> userInfoMap,
    String id,
  ) async {
    await _firestore.collection("users").doc(id).set(userInfoMap);
  }

  /// Email bo‘yicha foydalanuvchini qidiradi
  Future<QuerySnapshot> getUserByemail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  /// Qidiruv: foydalanuvchi username bo‘yicha (SearchKey orqali)
  Future<QuerySnapshot> Search(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("SearchKey", isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }

  /// Chat xonasini yaratadi (mavjud bo‘lmasa)
  Future<void> createChatRoom(
    String chatRoomId,
    Map<String, dynamic> chatRoomInfoMap,
  ) async {
    final snapshot =
        await _firestore.collection("chatrooms").doc(chatRoomId).get();
    if (!snapshot.exists) {
      await _firestore
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap, SetOptions(merge: true));
    }
  }

  Future addMessage(
    String chatRoomId,
    String messageId,
    Map<String, dynamic> messageInfoMap,
  ) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future<void> updateLastMessageSend(
    String chatRoomId, Map<String, dynamic> lastMessageInfoMap) async {
  return await FirebaseFirestore.instance
      .collection("chatrooms")
      .doc(chatRoomId)
      .update(lastMessageInfoMap);
}

}
