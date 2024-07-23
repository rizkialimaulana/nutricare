import 'package:flutter/material.dart';
import 'package:nutricare/root/screens/home_screen.dart';
import 'package:nutricare/root/screens/profile_screen.dart';
import 'package:nutricare/root/screens/calculate_screen.dart';
import 'package:nutricare/root/screens/setting_screen.dart';
import 'package:nutricare/root/modals/add_data_modal.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const CalculateScreen(),
    const SettingScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFFF7F7F7), // Set this to match your screen's background color
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            ),
            builder: (context) => AddDataModal(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.orange,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 60.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavigationItem(Icons.home_outlined, 0),
            _buildBottomNavigationItem(Icons.grid_view_outlined, 1),
            const SizedBox(
                width: 40), // The space for the floating action button
            _buildBottomNavigationItem(Icons.settings_outlined, 2),
            _buildBottomNavigationItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? Colors.white : Colors.lightBlueAccent,
        ),
      ),
    );
  }
}
