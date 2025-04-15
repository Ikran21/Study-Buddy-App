import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:study_buddy_app/componets/my_button.dart';
import 'package:study_buddy_app/componets/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in button
  void Signuserin() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Background Image
              Image.asset(
                "assets/images/gsu_study.jpeg",
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),

              // Welcome message
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  children: [
                    Text(
                      "Welcome to Study Buddy!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Subtitle message
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  children: [
                    Text(
                      "Find a study buddy near you",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Username text field
              MyTextfield(
                controller: emailController,
                hintText: "Enter Email",
                obscureText: false,
              ),
              const SizedBox(height: 20),

              // Password text field
              MyTextfield(
                controller: passwordController,
                hintText: "Enter Password",
                obscureText: true,
              ),
              const SizedBox(height: 15),

              // Forgot password
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Row(
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sign-in button
              MyButton(onTap: Signuserin),

              // Register / sign-up
              const SizedBox(height: 15),
              Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member? "),
                      Text(
                        "Sign up Now",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
