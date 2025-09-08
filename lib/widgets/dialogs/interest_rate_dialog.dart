import 'package:flutter/material.dart';

class InterestRateDialog extends StatefulWidget {
  @override
  _InterestRateDialogState createState() => _InterestRateDialogState();
}

class _InterestRateDialogState extends State<InterestRateDialog> {
  final _presentValueController = TextEditingController();
  final _futureValueController = TextEditingController();
  final _timeController = TextEditingController();

  void _calculateInterestRate(BuildContext context) {
    final presentValue = double.tryParse(_presentValueController.text) ?? 0;
    final futureValue = double.tryParse(_futureValueController.text) ?? 0;
    final time = double.tryParse(_timeController.text) ?? 0;

    if (presentValue <= 0 || time <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Valor presente y tiempo deben ser mayores a 0')));
      return;
    }

    final rate = ((futureValue / presentValue) - 1) / time * 100;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultado - Tasa de Interés'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Valor presente: \$${presentValue.toStringAsFixed(2)}'),
              Text('Valor futuro: \$${futureValue.toStringAsFixed(2)}'),
              Text('Tiempo: ${time.toStringAsFixed(2)} períodos'),
              SizedBox(height: 10),
              Text('Tasa de interés requerida: ${rate.toStringAsFixed(2)}%',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
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
      title: Text('Cálculo de Tasa de Interés'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _presentValueController,
              decoration: InputDecoration(
                  labelText: 'Valor Presente (VP)', hintText: 'Ej: 1000'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _futureValueController,
              decoration: InputDecoration(
                  labelText: 'Valor Futuro (VF)', hintText: 'Ej: 1500'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                  labelText: 'Tiempo (n) en períodos', hintText: 'Ej: 2.5'),
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
          onPressed: () => _calculateInterestRate(context),
          child: Text('Calcular'),
        ),
      ],
    );
  }
}
