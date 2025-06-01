/*import 'package:ex_chat_app/pages/home.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;
    String username = userDetails!.email!.replaceAll("@gmail.com", "");
    String firstletter = username.substring(0, 1).toUpperCase();
    await SharedpreferenceHelper()
        .saveUserDisplayName(userDetails.displayName!);
    await SharedpreferenceHelper().saveUserEmail(userDetails.email!);
    await SharedpreferenceHelper().saveUserId(userDetails.uid);
    await SharedpreferenceHelper().saveUserName(username.toUpperCase());
    await SharedpreferenceHelper().saveUserImage(userDetails.photoURL!);
     if (result.user != null) {
      Map<String, dynamic> userInfoMap = {
        "Name": userDetails.displayName,
        "Email": userDetails.email,
        "Image": userDetails.photoURL,
        "Id": userDetails.uid,
        "username": username.toUpperCase(),
        "SearchKey": firstletter
      };

      await DatabaseMethods()
          .addUser(userInfoMap, userDetails.uid)
          .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            )));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  Future SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteuser() async {
    User? user = await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}
*/
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods{
  final FirebaseAuth auth= FirebaseAuth.instance;

  getcurrentUser()async
  {
return await auth.currentUser;
  }
}