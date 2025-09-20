import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Brush twice a day for 2 minutes.',
      'Floss daily to remove plaque between teeth.',
      'Limit sugary snacks and drinks.',
      'Replace your toothbrush every 3–4 months.',
      'Visit a dentist every 6 months.',
      'Rinse after meals if brushing isn’t possible.',
      'Drink plenty of water to maintain saliva flow.',
      'Use a fluoride toothpaste.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips & Recommendations'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tips.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.check_circle_outline, color: Colors.teal),
          title: Text(tips[i]),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: Colors.teal.shade50,
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
      ),
    );
  }
}
