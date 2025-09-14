import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class TimeSelector extends StatelessWidget {
  final TextEditingController yearsController;
  final TextEditingController monthsController;
  final TextEditingController daysController;
  final String? Function(String?)? validator;

  const TimeSelector({
    required this.yearsController,
    required this.monthsController,
    required this.daysController,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiempo:',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildTimeField('Años', yearsController),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildTimeField('Meses', monthsController),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildTimeField('Días', daysController),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Nota: Ingresa 0 en los campos que no necesites',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white, fontSize: 14),
      keyboardType: TextInputType.number,
      validator: validator, // ← Pasar el validator
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.5),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
    );
  }
}
