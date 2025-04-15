import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {
  final Function()? onTap;
  
  const MyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 35),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius:BorderRadius.circular(8),
           ),
        child: const Center(
          child: Text("Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            
            ),
          ),
        ),
      ),
    );
  }
}