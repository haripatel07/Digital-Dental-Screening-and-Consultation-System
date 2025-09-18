import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final imagePath = args?['imagePath'] as String?;
    final imageBytes = args?['imageBytes'] as Uint8List?;
    final disease = args?['disease'] as String?;
    final confidence = args?['confidence'] as double?;
    final recommendation = args?['recommendation'] as String?;
    final source = args?['source'] as String?; // 'normal' or 'xray'

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
              children: [
                Icon(
                  source == 'xray' ? Icons.medical_services : Icons.camera_alt,
                  color: Colors.white,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  source == 'xray'
                      ? 'X-ray Analysis Result'
                      : 'Normal Image Analysis Result',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Image Preview
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: kIsWeb
                          ? (imageBytes == null
                              ? const Center(
                                  child: Text('No image provided',
                                      style: TextStyle(color: Colors.grey)))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(imageBytes,
                                      fit: BoxFit.cover),
                                ))
                          : (imagePath == null
                              ? const Center(
                                  child: Text('No image provided',
                                      style: TextStyle(color: Colors.grey)))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(File(imagePath),
                                      fit: BoxFit.cover),
                                )),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Results Section
                  _ResultTile(
                    title: "Predicted Condition",
                    value: disease ?? "—",
                    subtitle: disease == null
                        ? "Prediction will appear after backend integration."
                        : null,
                  ),
                  const SizedBox(height: 12),

                  _ResultTile(
                    title: "Confidence Score",
                    value: confidence == null
                        ? "—"
                        : "${(confidence).toStringAsFixed(1)} %",
                    subtitle: confidence == null
                        ? "Confidence score will be shown here."
                        : null,
                  ),
                  const SizedBox(height: 12),

                  _ResultTile(
                    title: "Dentist Recommendation",
                    value: recommendation ?? "—",
                    subtitle: recommendation == null
                        ? "Care instructions and dentist advice will appear here."
                        : null,
                    multiline: true,
                  ),

                  const SizedBox(height: 30),

                  // Back button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      icon: const Icon(Icons.home, color: Colors.white),
                      label: const Text("Back to Home",
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              maxLines: multiline ? null : 2,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(subtitle!, style: TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}
