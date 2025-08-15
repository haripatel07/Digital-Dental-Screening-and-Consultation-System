import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Upload Normal Image',
      'icon': Icons.camera_alt,
      'route': '/upload_normal'
    },
    {
      'title': 'Upload X-ray Image',
      'icon': Icons.medical_services,
      'route': '/upload_xray'
    },
    {'title': 'Chatbot', 'icon': Icons.chat, 'route': '/chatbot'},
    {
      'title': 'Tips & Recommendations',
      'icon': Icons.lightbulb,
      'route': '/tips'
    },
    {'title': 'Profile', 'icon': Icons.person, 'route': '/profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dental Care Home"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 items per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, menuItems[index]['route']);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(menuItems[index]['icon'], size: 50, color: Colors.teal),
                  SizedBox(height: 10),
                  Text(
                    menuItems[index]['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
