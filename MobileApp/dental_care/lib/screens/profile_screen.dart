import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clinics = [
      {'name': 'BrightSmile Dental', 'rating': 4.6, 'distance': '1.2 km'},
      {'name': 'City Care Dental', 'rating': 4.4, 'distance': '2.0 km'},
      {'name': 'Pearl Dental Studio', 'rating': 4.7, 'distance': '3.1 km'},
    ];

    return Scaffold(
      body: Column(
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.tealAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.teal),
                ),
                SizedBox(height: 12),
                Text(
                  'User Name',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'user@example.com',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinics header
                  const Row(
                    children: [
                      Icon(Icons.local_hospital, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Nearby Clinics',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Clinics list
                  ...clinics.map(
                    (c) => Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: const Icon(Icons.location_on,
                            color: Colors.teal, size: 30),
                        title: Text(c['name'] as String,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          '⭐ ${(c['rating'] as double).toStringAsFixed(1)} • ${c['distance']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Later: Maps / Call / Booking
                          },
                          child: const Text('Contact'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Doctor connect
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.teal, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // Later: chat or video consultation
                      },
                      icon: const Icon(Icons.video_call, color: Colors.teal),
                      label: const Text(
                        'Connect with a Doctor',
                        style: TextStyle(color: Colors.teal),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
