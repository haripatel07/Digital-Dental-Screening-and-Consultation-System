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
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                        radius: 28, child: Icon(Icons.person, size: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('User Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('user@example.com',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit',
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Clinics header
            Row(
              children: const [
                Icon(Icons.local_hospital, color: Colors.teal),
                SizedBox(width: 8),
                Text('Nearby Clinics',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),

            // Clinic list
            ...clinics.map((c) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.teal),
                    title: Text(c['name'] as String),
                    subtitle: Text(
                        'Rating: ${(c['rating'] as double).toStringAsFixed(1)} • ${c['distance']}'),
                    trailing: FilledButton(
                      onPressed: () {
                        // Later: Deep link / call / maps
                      },
                      child: const Text('Contact'),
                    ),
                  ),
                )),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Later: open doctor connect screen or start chat/video
                },
                icon: const Icon(Icons.video_call),
                label: const Text('Connect with a Doctor'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
