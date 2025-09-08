import 'package:flutter/material.dart';

class SimpleInterestDialog extends StatefulWidget {
  @override
  _SimpleInterestDialogState createState() => _SimpleInterestDialogState();
}

class _SimpleInterestDialogState extends State<SimpleInterestDialog> {
  final _capitalController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();

  void _calculateInterest(BuildContext context) {
    final capital = double.tryParse(_capitalController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final time = double.tryParse(_timeController.text) ?? 0;

    final interest = capital * (rate / 100) * time;
    final total = capital + interest;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultado - Interés Simple'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Capital inicial: \$${capital.toStringAsFixed(2)}'),
              Text('Tasa de interés: ${rate.toStringAsFixed(2)}%'),
              Text('Tiempo: ${time.toStringAsFixed(2)} períodos'),
              SizedBox(height: 10),
              Text('Interés generado: \$${interest.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Monto total: \$${total.toStringAsFixed(2)}',
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
      title: Text('Interés Simple'),
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _calculateInterest(context),
          child: Text('Calcular'),
        ),
      ],
    );
  }
}
