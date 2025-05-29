/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ex_chat_app/pages/home.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SigninState();
}

class _SigninState extends State<SignIn> {
  String email = "";
  String password = "";
  String name = "";
  String pic = "";
  String usernamse = "";
  String Id = "";

  TextEditingController usermailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      QuerySnapshot querySnapshot = await DatabaseMethods().getUserByemail(
        email,
      );

      name = "${querySnapshot.docs[0]['Name']}";
      usernamse = "${querySnapshot.docs[0]['Username']}";
      pic = "${querySnapshot.docs[0]['Photo']}";
      Id = querySnapshot.docs[0]['Id'];

      await  SharedPreferenceHelper().saveUserDisplayName(name);
      await SharedPreferenceHelper().saveUserName(usernamse);
      await SharedPreferenceHelper().saveUserId(Id);
      await SharedPreferenceHelper().saveUserPic(pic);
      


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided By User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3.5,
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    105.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      "Login to your account",
                      style: TextStyle(
                        color: Color(0xFFbbb0ff),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 30.0,
                        ),
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.0),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextFormField(
                                  controller: usermailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter E-mail';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF7f30fe),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                "Password",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.0),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: TextFormField(
                                  controller: userpasswordcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.password,
                                      color: Color(0xFF7f30fe),
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              GestureDetector(
                                onTap: () {
                                  if (_formkey.currentState!.validate()) {
                                    setState(() {
                                      email = usermailcontroller.text;
                                      password = userpasswordcontroller.text;
                                    });
                                     userLogin();
                                  }
                                 
                                },
                                child: Container(
                                  width: 130,
                                  child: Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          //color: Color(0xFF6380fb),
                                          color: Color(0xFF7f30fe),
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Sign In",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      Text(
                        "Sign Up Now",
                        style: TextStyle(
                          color: Color(0xFF7f30fe),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ex_chat_app/pages/home.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> userLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      QuerySnapshot querySnapshot = await DatabaseMethods().getUserByemail(email);

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs[0];
        await SharedPreferenceHelper().saveUserDisplayName(userData['Name']);
        await SharedPreferenceHelper().saveUserName(userData['Username']);
        await SharedPreferenceHelper().saveUserId(userData['Id']);
        await SharedPreferenceHelper().saveUserPic(userData['Photo']);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      final message = e.code == 'user-not-found'
          ? 'No user found for that email.'
          : e.code == 'wrong-password'
              ? 'Wrong password provided.'
              : 'Login failed. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height / 3.5,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(500, 105.0),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                const Text(
                  "Login to your account",
                  style: TextStyle(color: Color(0xFFbbb0ff), fontSize: 18.0),
                ),
                const SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextField(
                              controller: _emailController,
                              label: "Email",
                              hint: "Enter your email",
                              icon: Icons.email_outlined,
                            ),
                            const SizedBox(height: 20),
                            buildTextField(
                              controller: _passwordController,
                              label: "Password",
                              hint: "Enter your password",
                              icon: Icons.lock_outline,
                              obscure: true,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Navigate to Forgot Password screen
                                },
                                child: const Text("Forgot Password?", style: TextStyle(color: Colors.black87)),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7f30fe),
                                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 14.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                ),
                                onPressed: _isLoading ? null : userLogin,
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text("Sign In", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? ", style: TextStyle(fontSize: 16.0)),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to Sign Up screen
                      },
                      child: const Text(
                        "Sign Up Now",
                        style: TextStyle(
                          color: Color(0xFF7f30fe),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
              prefixIcon: Icon(icon, color: const Color(0xFF7f30fe)),
            ),
          ),
        ),
      ],
    );
  }
}
