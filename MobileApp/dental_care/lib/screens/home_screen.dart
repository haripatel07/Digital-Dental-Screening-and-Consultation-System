import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Upload Normal Image', Icons.camera_alt, '/upload_normal'),
      ('Upload X-ray Image', Icons.medical_services, '/upload_xray'),
      ('Chatbot', Icons.chat, '/chatbot'),
      ('Tips & Recommendations', Icons.lightbulb, '/tips'),
      ('Profile', Icons.person, '/profile'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dental Care Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return InkWell(
            onTap: () => Navigator.pushNamed(context, item.$3),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.$2, size: 44, color: Colors.teal),
                    const SizedBox(height: 10),
                    Text(item.$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
