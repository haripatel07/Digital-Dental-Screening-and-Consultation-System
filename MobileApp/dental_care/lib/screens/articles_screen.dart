import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  late Future<List<Map<String, dynamic>>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = ApiService().fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dental Articles')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found.'));
          }
          final articles = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final article = articles[i];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: ListTile(
                  title: Text(article['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: article['summary'] != null
                      ? Text(article['summary'])
                      : null,
                  trailing: const Icon(Icons.open_in_new, color: Colors.teal),
                  onTap: () async {
                    final url = article['url'] ?? '';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open article')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
