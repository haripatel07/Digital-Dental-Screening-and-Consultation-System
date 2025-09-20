import 'package:flutter/material.dart';
import 'package:dental_care/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_storage.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _clinics = [];
  bool _loading = false;
  String? _error;
  String? _city;
  Position? _position;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _detectLocationAndPromptCity();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _detectLocationAndPromptCity() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    String? cityName;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }
      final pos = await Geolocator.getCurrentPosition();
      _position = pos;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        cityName = placemarks.first.locality ??
            placemarks.first.subAdministrativeArea ??
            '';
      }
    } catch (e) {
      cityName = '';
    }
    await Future.delayed(Duration.zero); // Wait for build
    TextEditingController controller = TextEditingController(text: cityName);
    String? city = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter your city'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'City name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text.trim());
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    if (city != null && city.isNotEmpty) {
      setState(() {
        _city = city;
      });
      _fetchClinics(city);
    } else {
      setState(() {
        _error = 'City is required to fetch clinics.';
        _loading = false;
      });
    }
  }

  Future<void> _fetchClinics(String city) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final clinics = await _apiService.nearbyClinics(city);
      if (_disposed) return;
      setState(() {
        _clinics = clinics;
      });
    } catch (e) {
      if (_disposed) return;
      setState(() {
        _error = 'Failed to fetch clinics: [${e.toString()}';
      });
    } finally {
      if (_disposed) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
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
                  if (_loading)
                    const Center(child: CircularProgressIndicator()),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_error!, style: TextStyle(color: Colors.red)),
                    ),
                  if (!_loading && _error == null)
                    ..._clinics.map((c) => Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.location_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 30),
                            title: Text(c['name'] ?? 'Unknown Clinic',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['address'] ?? '',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                if (c['rating'] != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        c['rating'].toString(),
                                        style: const TextStyle(
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 110,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: c['phone'] != null &&
                                        c['phone'].toString().isNotEmpty
                                    ? () async {
                                        final phone = c['phone'].toString();
                                        final uri = Uri.parse('tel:$phone');
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Could not launch phone app')),
                                          );
                                        }
                                      }
                                    : null,
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
                      onPressed: () async {
                        await AuthStorage.clearToken();
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
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
