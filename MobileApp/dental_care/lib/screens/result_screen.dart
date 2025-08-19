import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final imagePath = args?['imagePath'] as String?;
    final disease = args?['disease'] as String?;
    final confidence = args?['confidence'] as double?;
    final recommendation = args?['recommendation'] as String?;
    final source = args?['source'] as String?; // 'normal' or 'xray'

    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    source == 'xray'
                        ? Icons.medical_services
                        : Icons.camera_alt,
                    color: Colors.teal),
                const SizedBox(width: 8),
                Text(
                  source == 'xray' ? 'X-ray Analysis' : 'Normal Image Analysis',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Image preview
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imagePath == null
                    ? const Center(child: Text('No image provided'))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(imagePath), fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Result cards
            _ResultTile(
              title: 'Predicted Condition',
              value: disease ?? '—',
              subtitle: disease == null
                  ? 'Prediction will appear after backend integration.'
                  : null,
            ),
            const SizedBox(height: 12),
            _ResultTile(
              title: 'Confidence',
              value: confidence == null
                  ? '—'
                  : '${(confidence * 100).toStringAsFixed(1)} %',
              subtitle: confidence == null
                  ? 'Confidence score will be shown here.'
                  : null,
            ),
            const SizedBox(height: 12),
            _ResultTile(
              title: 'Recommendation',
              value: (recommendation ?? '—'),
              subtitle: recommendation == null
                  ? 'Dentist recommendations and care tips will be displayed here.'
                  : null,
              multiline: true,
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/home'),
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final bool multiline;

  const _ResultTile({
    required this.title,
    required this.value,
    this.subtitle,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16),
              maxLines: multiline ? null : 2,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ],
        ),
      ),
    );
  }
}
