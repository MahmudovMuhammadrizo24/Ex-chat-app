/*import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();


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
                        
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextField(
                              controller: _emailController,
                              label: "Email",
                              hint: "Enter your email",
                              icon: Icons.email_outlined,
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
}*/
import 'package:ex_chat_app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  void sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email has been sent.', style: TextStyle(fontSize: 18.0)),
            backgroundColor: Colors.green,
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user found for that email.', style: TextStyle(fontSize: 18.0)),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
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
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              children: [
                const Text(
                  "Forgot Password",
                  style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                const Text(
                  "Enter your email to reset password",
                  style: TextStyle(color: Color(0xFFbbb0ff), fontSize: 16.0),
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
                            const SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : sendResetLink,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7f30fe),
                                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        "Send Reset Email",
                                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Signup()),
                        );
                      },
                      child: const Text(
                        "Sign Up now!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 151, 92, 246),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextFormField(
            controller: controller,
            validator: (value) =>
                value == null || value.isEmpty ? 'Please enter your $label' : null,
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
