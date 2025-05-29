/*
import 'package:ex_chat_app/pages/home.dart';
import 'package:ex_chat_app/pages/signin.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String name = "", email = "", password = "", confirmPassword = "";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (_formKey.currentState!.validate()) {
      if (password != null && password == confirmPassword) {
        try {
          // Generate random ID
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: mailController.text.trim(),
                password: passwordController.text.trim(),
              );
          String Id = randomAlphaNumeric(10);
          String user = mailController.text.replaceAll("@gmail.com", "");
          String updateusername = user.replaceFirst(
            user[0],
            user[0].toUpperCase(),
          );
          String firstletter = user.substring(0, 1).toUpperCase();

          //String uid = userCredential.user!.uid;

          Map<String, dynamic> userInfoMap = {
            "Name": nameController.text,
            "E-mail": mailController.text,
            "username": updateusername.toUpperCase(),
            "SearchKey": firstletter,
            "Photo":
                "https://www.shutterstock.com/image-vector/people-icon-vector-person-sing-260nw-707883430.jpg",
            "Id": Id,
          };
          await DatabaseMethods().addUserDetails(userInfoMap, Id);
          await SharedPreferenceHelper().saveUserId(Id);
          await SharedPreferenceHelper().saveUserDisplayName(
            nameController.text,
          );
          await SharedPreferenceHelper().saveUserEmail(mailController.text);
          await SharedPreferenceHelper().saveUserPic(
            "https://www.shutterstock.com/image-vector/people-icon-vector-person-sing-260nw-707883430.jpg",
          );
          await SharedPreferenceHelper().saveUserName(
            mailController.text.replaceAll("@gmail.com", ""),
          );

          // Success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Registration Successful!",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );

          // Clear fields
          nameController.clear();
          mailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } on FirebaseAuthException catch (e) {
          String message = "Something went wrong";
          if (e.code == 'weak-password') {
            message = "Password Provided is too Weak";
          } else if (e.code == 'email-already-in-use') {
            message = "Account with this email already exists";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message, style: TextStyle(fontSize: 18.0)),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Passwords do not match",
              style: TextStyle(fontSize: 18.0),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(400, 105.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Center(
                  child: Text(
                    "Create a New Account",
                    style: TextStyle(
                      color: Color(0xFFbbb0ff),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            buildTextFormField(
                              label: "Name",
                              icon: Icons.person_outline,
                              controller: nameController,
                              onChanged: (value) => name = value,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? "Please enter your name"
                                          : null,
                            ),
                            const SizedBox(height: 15.0),
                            buildTextFormField(
                              label: "Email",
                              icon: Icons.email_outlined,
                              controller: mailController,
                              onChanged: (value) => email = value,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? "Please enter your email"
                                          : null,
                            ),
                            const SizedBox(height: 15.0),
                            buildTextFormField(
                              label: "Password",
                              icon: Icons.lock_outline,
                              controller: passwordController,
                              obscureText: true,
                              onChanged: (value) => password = value,
                              validator:
                                  (value) =>
                                      value!.length < 6
                                          ? "Password must be at least 6 characters"
                                          : null,
                            ),
                            const SizedBox(height: 15.0),
                            buildTextFormField(
                              label: "Confirm Password",
                              icon: Icons.lock,
                              controller: confirmPasswordController,
                              obscureText: true,
                              onChanged: (value) => confirmPassword = value,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? "Please confirm your password"
                                          : null,
                            ),

                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignIn(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Color(0xFF7f30fe),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ), // chap va o‘ngdan joy
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: registration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7f30fe),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),

                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    required ValueChanged<String> onChanged,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF7f30fe)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
      ],
    );
  }
}
*/

import 'package:ex_chat_app/pages/home.dart';
import 'package:ex_chat_app/pages/signin.dart';
import 'package:ex_chat_app/service/database.dart';
import 'package:ex_chat_app/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> registration() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text == confirmPasswordController.text) {
        setState(() => isLoading = true);

        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );

          String userId = randomAlphaNumeric(10);
          String username = emailController.text
              .split('@')[0]
              .replaceFirstMapped(
                RegExp(r'^.'),
                (match) => match.group(0)!.toUpperCase(),
              );
          String firstLetter = username.substring(0, 1).toUpperCase();

          Map<String, dynamic> userInfoMap = {
            "Name": nameController.text.trim(),
            "E-mail": emailController.text.trim(),
            "username": username,
            "SearchKey": firstLetter,
            "Photo":
                "https://www.shutterstock.com/image-vector/people-icon-vector-person-sing-260nw-707883430.jpg",
            "Id": userId,
          };

          // Store to Firestore
          await DatabaseMethods().addUserDetails(userInfoMap, userId);

          // Save locally
          await SharedPreferenceHelper().saveUserId(userId);
          await SharedPreferenceHelper().saveUserDisplayName(
            nameController.text.trim(),
          );
          await SharedPreferenceHelper().saveUserEmail(
            emailController.text.trim(),
          );
          await SharedPreferenceHelper().saveUserPic(
            "https://www.shutterstock.com/image-vector/people-icon-vector-person-sing-260nw-707883430.jpg",
          );
          await SharedPreferenceHelper().saveUserName(username);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Successful!")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } on FirebaseAuthException catch (e) {
          String errorMsg = "Something went wrong";
          if (e.code == 'weak-password') {
            errorMsg = "Password is too weak";
          } else if (e.code == 'email-already-in-use') {
            errorMsg = "Email already in use";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
          );
        } finally {
          setState(() => isLoading = false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(400, 105),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Center(
                          child: Text(
                            "Create a New Account",
                            style: TextStyle(
                              color: Color(0xFFbbb0ff),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 6,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    buildTextField(
                                      label: "Name",
                                      icon: Icons.person_outline,
                                      controller: nameController,
                                      validator:
                                          (value) =>
                                              value!.isEmpty
                                                  ? "Enter your name"
                                                  : null,
                                    ),
                                    const SizedBox(height: 15),
                                    buildTextField(
                                      label: "Email",
                                      icon: Icons.email_outlined,
                                      controller: emailController,
                                      validator:
                                          (value) =>
                                              value!.isEmpty
                                                  ? "Enter your email"
                                                  : null,
                                    ),
                                    const SizedBox(height: 15),
                                    buildTextField(
                                      label: "Password",
                                      icon: Icons.lock_outline,
                                      controller: passwordController,
                                      validator:
                                          (value) =>
                                              value!.length < 6
                                                  ? "Min 6 characters"
                                                  : null,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 15),
                                    buildTextField(
                                      label: "Confirm Password",
                                      icon: Icons.lock,
                                      controller: confirmPasswordController,
                                      validator:
                                          (value) =>
                                              value!.isEmpty
                                                  ? "Confirm password"
                                                  : null,
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Already have an account? "),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => const SignIn(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Sign In",
                                            style: TextStyle(
                                              color: Color(0xFF7f30fe),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF7f30fe,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            isLoading ? null : registration,
                                        child:
                                            isLoading
                                                ? const SizedBox(
                                                  height: 24,
                                                  width: 24,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(Colors.white),
                                                  ),
                                                )
                                                : const Text(
                                                  "Sign In",
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
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
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF7f30fe)),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }
}













/* conntroller 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> registration() async {
    if (_formKey.currentState!.validate()) {
      final email = mailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Successful!")),
        );
      } on FirebaseAuthException catch (e) {
        String message = "An error occurred";
        if (e.code == 'weak-password') {
          message = "Password provided is too weak";
        } else if (e.code == 'email-already-in-use') {
          message = "Account with this email already exists";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width, 105.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Create a New Account",
                  style: TextStyle(color: Color(0xFFbbb0ff), fontSize: 18),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade300)],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Name"),
                            _buildTextField(
                              controller: nameController,
                              icon: Icons.person_outline,
                              hint: "Enter your name",
                              validator: (value) => value!.isEmpty ? "Please enter your name" : null,
                            ),
                            _buildLabel("Email"),
                            _buildTextField(
                              controller: mailController,
                              icon: Icons.email_outlined,
                              hint: "Enter your email",
                              validator: (value) {
                                if (value!.isEmpty) return "Please enter your email";
                                if (!value.contains('@')) return "Enter a valid email";
                                return null;
                              },
                            ),
                            _buildLabel("Password"),
                            _buildTextField(
                              controller: passwordController,
                              icon: Icons.lock_outline,
                              hint: "Enter your password",
                              obscureText: true,
                              validator: (value) => value!.length < 6 ? "Minimum 6 characters" : null,
                            ),
                            _buildLabel("Confirm Password"),
                            _buildTextField(
                              controller: confirmPasswordController,
                              icon: Icons.lock_outline,
                              hint: "Confirm your password",
                              obscureText: true,
                              validator: (value) =>
                                  value != passwordController.text ? "Passwords do not match" : null,
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: registration,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF7f30fe),
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to login
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Color(0xFF7f30fe),
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          prefixIcon: Icon(icon, color: Color(0xFF7f30fe)),
        ),
      ),
    );
  }
}
 
 */