import 'package:flutter/material.dart';

class UploadXrayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload X-ray Image")),
      body: Center(
        child: Text(
          "Upload X-ray Image Screen",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
