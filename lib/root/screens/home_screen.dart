import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDates;
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekDates = _generateWeekDates(_selectedDate);

    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName = userDoc['first_name'] + ' ' + userDoc['last_name'];
      });
    }
  }

  List<DateTime> _generateWeekDates(DateTime currentDate) {
    final startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Morning,',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        _userName,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      'https://example.com/profile.jpg', // Placeholder image URL
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              _buildDaySelector(),
              const SizedBox(height: 16),
              const Text(
                'Morning',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildMealCard(
                      'Omega-3',
                      '2 pcs of Tuna',
                      '08:00 am',
                      Icons.healing,
                      Colors.orange[100]!,
                      '20 Grams',
                    ),
                    _buildMealCard(
                      'Carbo',
                      '0.5kg of rice',
                      '08:00 am',
                      Icons.health_and_safety_outlined,
                      Colors.blue[100]!,
                      '1 Kilos',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDates.map((date) {
        return _buildDayButton(date);
      }).toList(),
    );
  }

  Widget _buildDayButton(DateTime date) {
    bool isSelected = date.day == _selectedDate.day &&
        date.month == _selectedDate.month &&
        date.year == _selectedDate.year;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              DateFormat('dd').format(date),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('E')
                .format(date)
                .substring(0, 2), // Short day of the week
            style: TextStyle(
              color: isSelected ? Colors.orange : Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(String title, String pieces, String time, IconData icon,
      Color color, String tabs) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  tabs,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),
                Icon(
                  icon,
                  color: Colors.red,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$pieces',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
