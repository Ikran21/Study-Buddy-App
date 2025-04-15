import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:study_buddy_app/componets/my_button.dart';
import 'package:study_buddy_app/componets/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in button
  void Signuserin() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),

              // logo
              Icon(
                Icons.lock,
                size: 100,
              ),
              SizedBox(height: 30),

              // welcome back message
              Text(
                "Welcome to Study Buddy",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 30),

              // username text field
              MyTextfield(
                controller: emailController,
                hintText: "enter Email",
                obscureText: false,
              ),
              SizedBox(height: 30),

              // password text field
              MyTextfield(
                controller: passwordController,
                hintText: "enter password",
                obscureText: true,
              ),

              //Add forgot password, 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?",
                    style: TextStyle(color: Colors.grey),),
                  ],
                ),
              ),
              SizedBox(height: 30),
              //signin button, 
              MyButton(
                onTap: Signuserin,
                
              )
              
              //social sign-in options here
            ],
          ),
        ),
      ),
    );
  }
}
