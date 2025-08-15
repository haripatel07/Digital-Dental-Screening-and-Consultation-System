import 'package:flutter/material.dart';

class UploadNormalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Normal Image")),
      body: Center(
        child: Text(
          "Upload Normal Image Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
