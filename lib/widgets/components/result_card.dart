import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ResultCard extends StatelessWidget {
  final String resultText;
  final double resultValue;

  const ResultCard({
    required this.resultText,
    required this.resultValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppConstants.neonBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Resultado:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            resultText,
            style: TextStyle(
              fontSize: 16,
              color: resultValue > 0 ? AppConstants.neonBlue : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
