import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadNormalScreen extends StatefulWidget {
  const UploadNormalScreen({super.key});

  @override
  State<UploadNormalScreen> createState() => _UploadNormalScreenState();
}

class _UploadNormalScreenState extends State<UploadNormalScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickFromGallery() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _imageFile = File(x.path));
  }

  Future<void> _pickFromCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera);
    if (x != null) setState(() => _imageFile = File(x.path));
  }

  void _goToResult() {
    Navigator.pushNamed(
      context,
      '/result',
      arguments: {
        'imagePath': _imageFile?.path,
        // Leave values empty for now — UI is complete; backend will fill these.
        'disease': null,
        'confidence': null,
        'recommendation': null,
        'source': 'normal',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAnalyze = _imageFile != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Normal Image')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile == null
                    ? const Center(child: Text('No image selected'))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 12),
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: canAnalyze ? _goToResult : null,
                icon: const Icon(Icons.analytics),
                label: const Text('Analyze'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
