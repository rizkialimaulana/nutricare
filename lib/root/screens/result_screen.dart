import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // Contoh data hasil perhitungan nutrisi
  final List<Map<String, String>> _nutritionResults = [
    {
      'name': 'Oatmeal',
      'description': 'High in fiber and helps in reducing cholesterol.',
    },
    {
      'name': 'Salmon',
      'description': 'Rich in Omega-3 fatty acids and good for heart health.',
    },
    {
      'name': 'Spinach',
      'description': 'Packed with iron and vitamins A and C.',
    },
    {
      'name': 'Greek Yogurt',
      'description': 'Excellent source of protein and probiotics.',
    },
    {
      'name': 'Almonds',
      'description': 'Rich in healthy fats, fiber, and protein.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _nutritionResults.length,
          itemBuilder: (context, index) {
            final item = _nutritionResults[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  item['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(item['description']!),
                leading: Icon(Icons.fastfood, color: Colors.green[700]),
              ),
            );
          },
        ),
      ),
    );
  }
}
