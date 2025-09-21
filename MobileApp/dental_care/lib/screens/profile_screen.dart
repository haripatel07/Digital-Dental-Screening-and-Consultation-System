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
  Map<String, dynamic>? _userDetails;
  bool _loadingUserDetails = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _detectLocationAndPromptCity();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    try {
      final token = await AuthStorage.getToken();
      if (token != null) {
        final details = await _apiService.getUserDetails(token);
        if (_disposed) return;
        setState(() {
          _userDetails = details;
          if (details['city'] != null &&
              details['city'].toString().isNotEmpty) {
            _city = details['city'];
          }
        });
      }
    } catch (e) {
      if (_disposed) return;
      setState(() {
        _error = 'Failed to load user details';
      });
    } finally {
      if (_disposed) return;
      setState(() {
        _loadingUserDetails = false;
      });
    }
  }

  Future<void> _showEditProfileDialog() async {
    final nameController =
        TextEditingController(text: _userDetails?['name'] ?? '');
    final phoneController =
        TextEditingController(text: _userDetails?['phone'] ?? '');
    final addressController =
        TextEditingController(text: _userDetails?['address'] ?? '');
    final cityController =
        TextEditingController(text: _userDetails?['city'] ?? '');
    final ageController =
        TextEditingController(text: _userDetails?['age']?.toString() ?? '');

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedData = <String, dynamic>{};
              if (nameController.text.isNotEmpty)
                updatedData['name'] = nameController.text;
              if (phoneController.text.isNotEmpty)
                updatedData['phone'] = phoneController.text;
              if (addressController.text.isNotEmpty)
                updatedData['address'] = addressController.text;
              if (cityController.text.isNotEmpty)
                updatedData['city'] = cityController.text;
              if (ageController.text.isNotEmpty) {
                final age = int.tryParse(ageController.text);
                if (age != null) updatedData['age'] = age;
              }
              Navigator.pop(context, updatedData);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      await _updateUserDetails(result);
    }
  }

  Future<void> _updateUserDetails(Map<String, dynamic> updates) async {
    try {
      final token = await AuthStorage.getToken();
      if (token != null) {
        final updatedUser = await _apiService.updateUserDetails(
          token,
          name: updates['name'],
          phone: updates['phone'],
          address: updates['address'],
          city: updates['city'],
          age: updates['age'],
        );
        if (_disposed) return;
        setState(() {
          _userDetails = updatedUser;
          if (updatedUser['city'] != null && updatedUser['city'] != _city) {
            _city = updatedUser['city'];
            _fetchClinics(_city!);
          }
        });
      }
    } catch (e) {
      if (_disposed) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    }
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
                Text(
                  _userDetails?['name'] ?? 'User Name',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(_userDetails?['email'] ?? 'user@example.com',
                    style: const TextStyle(color: Colors.white70)),
                if (_userDetails?['phone'] != null)
                  Text('📞 ${_userDetails!['phone']}',
                      style: const TextStyle(color: Colors.white70)),
                if (_userDetails?['age'] != null)
                  Text('Age: ${_userDetails!['age']}',
                      style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _showEditProfileDialog,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
                    ..._clinics.map((c) {
                      final contact = c['contact'] ?? {};
                      final phone = contact['phone'] ?? '';
                      final website = contact['website'] ?? '';
                      final email = contact['email'] ?? '';
                      return Card(
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
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
                              if (phone.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
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
                                  },
                                  child: Text('📞 $phone',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                              if (website.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    final uri = Uri.parse(
                                        website.startsWith('http')
                                            ? website
                                            : 'https://$website');
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Could not launch website')),
                                      );
                                    }
                                  },
                                  child: Text('🌐 Website',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                              if (email.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    final uri = Uri.parse('mailto:$email');
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Could not launch email app')),
                                      );
                                    }
                                  },
                                  child: Text('✉️ $email',
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          decoration:
                                              TextDecoration.underline)),
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
                              onPressed: phone.isNotEmpty
                                  ? () async {
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
                      );
                    }),
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
