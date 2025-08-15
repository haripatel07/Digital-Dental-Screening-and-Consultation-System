import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dental Tips & Recommendations")),
      body: Center(
        child: Text(
          "Tips & Recommendations Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
