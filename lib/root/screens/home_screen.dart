import 'package:flutter/material.dart';
import 'package:nutricare/root/screens/calculate_screen.dart';
import 'package:nutricare/root/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to NutriCare!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your personal nutrition assistant for a healthy pregnancy.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildFeatureCard(
                    context,
                    Icons.calculate,
                    'Calculate Nutrition',
                    'Calculate your daily nutritional needs.',
                    () {
                      // Navigate to CalculateScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalculateScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.person,
                    'Profile',
                    'View and edit your profile.',
                    () {
                      // Navigate to ProfileScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.fastfood,
                    'Nutrition Tips',
                    'Get tips on healthy eating.',
                    () {
                      // Add your navigation or action here
                    },
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.history,
                    'History',
                    'View your nutrition history.',
                    () {
                      // Add your navigation or action here
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title,
      String description, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.green[700]),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
