import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
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
          // Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,
                      size: 50, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: 12),
                const Text(
                  'User Name',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text('user@example.com',
                    style: TextStyle(color: Colors.white70)),
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
                  const Row(
                    children: [
                      Icon(Icons.local_hospital, color: Colors.teal),
                      SizedBox(width: 8),
                      Text("Nearby Clinics",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  //  Clinics List
                  ...clinics.map((c) => Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.location_on,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30),
                          title: Text(c['name'] as String,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                            ' ${(c['rating'] as double).toStringAsFixed(1)} • ${c['distance']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
                              child: const Text("Contact"),
                            ),
                          ),
                        ),
                      )),

                  const SizedBox(height: 20),

                  //  Doctor Connect
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.video_call,
                          color: Theme.of(context).colorScheme.primary),
                      label: Text("Connect with a Doctor",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  //  Logout
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
                      label: const Text("Logout",
                          style: TextStyle(color: Colors.white)),
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
