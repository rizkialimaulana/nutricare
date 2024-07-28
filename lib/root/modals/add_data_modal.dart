import 'package:flutter/material.dart';

class AddDataModal extends StatelessWidget {
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
          _buildTextField("Weight (kg)", "e.g., 70"),
          const SizedBox(height: 16.0),
          _buildTextField("Height (cm)", "e.g., 170"),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add your action here
              },
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
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hintText, {int maxLines = 1}) {
    return TextField(
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
        // Add your action here
      },
    );
  }

  List<String> _getDropdownItems(String label) {
    switch (label) {
      case "Gender":
        return ["Male", "Female"];
      case "Activity Level":
        return [
          "Sedentary",
          "Lightly Active",
          "Moderately Active",
          "Very Active",
          "Extra Active"
        ];
      default:
        return [label];
    }
  }
}
