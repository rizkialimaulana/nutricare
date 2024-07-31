import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDataModal extends StatefulWidget {
  @override
  _AddDataModalState createState() => _AddDataModalState();
}

class _AddDataModalState extends State<AddDataModal> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _activityLevel = "Sedentary";
  String _trimester = "First";
  String _result = "";

  void _calculateNutrition() async {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text) / 100;
    int age = int.parse(_ageController.text);

    // Calculate BMI
    double bmi = weight / (height * height);
    String bmiCategory;
    if (bmi < 18.5) {
      bmiCategory = "Underweight";
    } else if (bmi < 25) {
      bmiCategory = "Normal weight";
    } else if (bmi < 30) {
      bmiCategory = "Overweight";
    } else {
      bmiCategory = "Obesity";
    }

    // Get user id from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      setState(() {
        _result = "User not logged in";
      });
      return;
    }
    String userId = user.uid;

    // Calculate BMR using Mifflin-St Jeor equation
    double bmr = 10 * weight + 6.25 * (height * 100) - 5 * age - 161;

    // Calculate TDEE based on activity level
    double activityMultiplier;
    switch (_activityLevel) {
      case "Sedentary":
        activityMultiplier = 1.2;
        break;
      case "Lightly Active":
        activityMultiplier = 1.375;
        break;
      case "Moderately Active":
        activityMultiplier = 1.55;
        break;
      case "Very Active":
        activityMultiplier = 1.725;
        break;
      case "Extra Active":
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }
    double tdee = bmr * activityMultiplier;

    // Add additional caloric needs based on trimester
    double additionalCalories;
    switch (_trimester) {
      case "First":
        additionalCalories = 85;
        break;
      case "Second":
        if (bmi < 18.5) {
          additionalCalories = 350;
        } else if (bmi < 25) {
          additionalCalories = 285;
        } else if (bmi < 30) {
          additionalCalories = 200;
        } else {
          additionalCalories = 150;
        }
        break;
      case "Third":
        if (bmi < 18.5) {
          additionalCalories = 500;
        } else if (bmi < 25) {
          additionalCalories = 475;
        } else if (bmi < 30) {
          additionalCalories = 300;
        } else {
          additionalCalories = 200;
        }
        break;
      default:
        additionalCalories = 0;
    }
    double totalCalories = tdee + additionalCalories;

    setState(() {
      _result =
          "BMI: ${bmi.toStringAsFixed(1)} ($bmiCategory)\nTDEE: ${tdee.toStringAsFixed(1)} kcal/day\nTotal Caloric Needs: ${totalCalories.toStringAsFixed(1)} kcal/day";
    });

    // Store the result in Firestore
    await FirebaseFirestore.instance.collection('nutrition_results').add({
      'userId': userId,
      'weight': weight,
      'height': height * 100,
      'age': age,
      'activityLevel': _activityLevel,
      'trimester': _trimester,
      'bmi': bmi,
      'bmiCategory': bmiCategory,
      'bmr': bmr,
      'tdee': tdee,
      'totalCalories': totalCalories,
      'timestamp': Timestamp.now(),
    });

    // Close the modal after submitting
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              height: 4.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            const Text(
              "Calculate Nutrition",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),
            _buildTextField("Weight (kg)", "e.g., 70", _weightController),
            const SizedBox(height: 16.0),
            _buildTextField("Height (cm)", "e.g., 170", _heightController),
            const SizedBox(height: 16.0),
            _buildTextField("Age (years)", "e.g., 30", _ageController),
            const SizedBox(height: 16.0),
            _buildDropdown("Activity Level", _activityLevel),
            const SizedBox(height: 16.0),
            _buildDropdown("Trimester", _trimester),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _calculateNutrition,
                icon: const Icon(Icons.calculate, color: Colors.white),
                label: const Text("Calculate",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _result,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String hintText, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildDropdown(String label, String value) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      value: value,
      items: _getDropdownItems(label).map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          switch (label) {
            case "Activity Level":
              _activityLevel = newValue!;
              break;
            case "Trimester":
              _trimester = newValue!;
              break;
          }
        });
      },
    );
  }

  List<String> _getDropdownItems(String label) {
    switch (label) {
      case "Activity Level":
        return [
          "Sedentary",
          "Lightly Active",
          "Moderately Active",
          "Very Active",
          "Extra Active"
        ];
      case "Trimester":
        return ["First", "Second", "Third"];
      default:
        return [label];
    }
  }
}
