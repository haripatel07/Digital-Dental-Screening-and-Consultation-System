import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dental_care/services/api_service.dart';
import 'dart:typed_data';

class UploadXrayScreen extends StatefulWidget {
  const UploadXrayScreen({super.key});

  @override
  State<UploadXrayScreen> createState() => _UploadXrayScreenState();
}

class _UploadXrayScreenState extends State<UploadXrayScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  Uint8List? _imageBytes; // For web
  bool _loading = false;
  String? _error;
  final ApiService _apiService = ApiService();

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(picked.path);
          _imageBytes = null;
        });
      }
    }
  }

  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(picked.path);
          _imageBytes = null;
        });
      }
    }
  }

  Future<void> _analyzeAndGoToResult() async {
    if (_imageFile == null && _imageBytes == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      Map<String, dynamic> result;
      if (kIsWeb && _imageBytes != null) {
        result = await _apiService.predictXrayWeb(_imageBytes!);
      } else if (_imageFile != null) {
        result = await _apiService.predictXray(_imageFile!.path);
      } else {
        throw Exception('No image selected');
      }
      Navigator.pushNamed(
        context,
        '/result',
        arguments: {
          'imagePath': _imageFile != null ? _imageFile!.path : '',
          'imageBytes': kIsWeb ? _imageBytes : null,
          'disease': result['prediction'],
          'confidence': result['confidence'],
          'recommendation': result['recommendation'],
          'source': 'xray',
        },
      );
    } catch (e) {
      setState(() {
        _error = 'Failed to analyze image. Please try again.';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canAnalyze =
        (kIsWeb ? _imageBytes != null : _imageFile != null) && !_loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload X-ray Image')),
      body: Column(
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_error!, style: TextStyle(color: Colors.red)),
            ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Preview box
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                      ),
                      child: kIsWeb
                          ? (_imageBytes == null
                              ? const Center(
                                  child: Text(
                                    'No image selected',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(_imageBytes!,
                                      fit: BoxFit.cover),
                                ))
                          : (_imageFile == null
                              ? const Center(
                                  child: Text(
                                    'No image selected',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_imageFile!,
                                      fit: BoxFit.cover),
                                )),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Buttons row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickFromCamera,
                          icon: const Icon(Icons.photo_camera),
                          label: const Text('Camera'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: canAnalyze ? _analyzeAndGoToResult : null,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Analyze'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
