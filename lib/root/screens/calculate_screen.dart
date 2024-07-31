import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  List<DocumentSnapshot> _results = [];
  List<DocumentSnapshot> _foodRecommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchResults();
    _fetchFoodRecommendations();
  }

  Future<void> _refreshResults() async {
    await _fetchResults();
    await _fetchFoodRecommendations();
  }

  Future<void> _fetchResults() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('nutrition_results').get();
    setState(() {
      _results = snapshot.docs;
    });
  }

  Future<void> _fetchFoodRecommendations() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('food_recommendations')
        .get();
    setState(() {
      _foodRecommendations = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalCalories =
        _results.isNotEmpty ? _results.last['totalCalories'] : 0;
    double tdee = _results.isNotEmpty ? _results.last['tdee'] : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshResults,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Calculate Nutrition',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatusCards(totalCalories, tdee),
                const SizedBox(height: 16),
                const Text(
                  'Food Recommendations',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFoodRecommendationsList(totalCalories),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCards(double totalCalories, double tdee) {
    return Row(
      children: [
        Expanded(
          child: _buildStatusCard(
            title: 'Total Calories',
            value: totalCalories.toStringAsFixed(1),
            unit: 'kcal/day',
            color: Colors.purple,
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatusCard(
            title: 'TDEE',
            value: tdee.toStringAsFixed(1),
            unit: 'kcal/day',
            color: Colors.blue,
            icon: Icons.bar_chart,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodRecommendationsList(double totalCalories) {
    List<DocumentSnapshot> filteredRecommendations = _foodRecommendations
        .where((rec) => (rec['kalori'] as num).toDouble() <= totalCalories)
        .toList();

    if (filteredRecommendations.isEmpty) {
      return const Center(
        child: Text(
          'No food recommendations available.',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      );
    }

    return Column(
      children: filteredRecommendations.map((rec) {
        return _buildFoodRecommendationCard(
          name: rec['name'],
          portion: rec['porsi'],
          calories: rec['kalori'],
          iron: rec['zat_besi'],
        );
      }).toList(),
    );
  }

  Widget _buildFoodRecommendationCard({
    required String name,
    required num portion,
    required num calories,
    required num iron,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: const Icon(Icons.fastfood, size: 40, color: Colors.green),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Portion: ${portion.toString()}'),
              Text('Calories: ${calories.toString()} kcal'),
              Text('Iron: ${iron.toString()} mg'),
            ],
          ),
        ),
      ),
    );
  }
}
