import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadXrayScreen extends StatefulWidget {
  const UploadXrayScreen({super.key});

  @override
  State<UploadXrayScreen> createState() => _UploadXrayScreenState();
}

class _UploadXrayScreenState extends State<UploadXrayScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _goToResult() {
    Navigator.pushNamed(
      context,
      '/result',
      arguments: {
        'imagePath': _imageFile?.path,
        'disease': null, // Will be populated by backend
        'confidence': null,
        'recommendation': null,
        'source': 'xray',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAnalyze = _imageFile != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload X-ray Image')),
      body: Column(
        children: [
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
                      child: _imageFile == null
                          ? const Center(
                              child: Text(
                                'No image selected',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            ),
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

          // Bottom analyze button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: canAnalyze ? _goToResult : null,
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
