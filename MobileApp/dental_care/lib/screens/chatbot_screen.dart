import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dental Chatbot")),
      body: Center(
        child: Text(
          "Chatbot Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
