import 'package:flutter/material.dart';
import 'dart:math';

class CompoundInterestDialog extends StatefulWidget {
  @override
  _CompoundInterestDialogState createState() => _CompoundInterestDialogState();
}

class _CompoundInterestDialogState extends State<CompoundInterestDialog> {
  final _capitalController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();
  final _compoundingController = TextEditingController(text: '1');

  void _calculateCompoundInterest(BuildContext context) {
    final capital = double.tryParse(_capitalController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final time = double.tryParse(_timeController.text) ?? 0;
    final compounding = int.tryParse(_compoundingController.text) ?? 1;

    final rateDecimal = rate / 100;
    final total =
        capital * pow(1 + rateDecimal / compounding, compounding * time);
    final interest = total - capital;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultado - Interés Compuesto'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Capital inicial: \$${capital.toStringAsFixed(2)}'),
              Text('Tasa anual: ${rate.toStringAsFixed(2)}%'),
              Text('Tiempo: ${time.toStringAsFixed(2)} años'),
              Text('Capitalización: $compounding veces por año'),
              SizedBox(height: 10),
              Text('Interés generado: \$${interest.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Monto futuro: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Interés Compuesto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _capitalController,
              decoration: InputDecoration(
                  labelText: 'Capital inicial (P)', hintText: 'Ej: 1000'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _rateController,
              decoration: InputDecoration(
                  labelText: 'Tasa de interés anual (i) %',
                  hintText: 'Ej: 5.5'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                  labelText: 'Tiempo (n) en años', hintText: 'Ej: 2.5'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _compoundingController,
              decoration: InputDecoration(
                  labelText: 'Veces de capitalización por año',
                  hintText: 'Ej: 12 (mensual)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _calculateCompoundInterest(context),
          child: Text('Calcular'),
        ),
      ],
    );
  }
}
