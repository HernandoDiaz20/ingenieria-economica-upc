import 'package:flutter/material.dart';
import 'dart:math';

class AnnuitiesDialog extends StatefulWidget {
  @override
  _AnnuitiesDialogState createState() => _AnnuitiesDialogState();
}

class _AnnuitiesDialogState extends State<AnnuitiesDialog> {
  final _paymentController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();

  String _annuityType = 'ordinary'; // vencida o anticipada
  String _calculationType = 'VA'; // VA (Valor Actual) o VF (Valor Futuro)

  void _calculateAnnuity(BuildContext context) {
    final payment = double.tryParse(_paymentController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final time = double.tryParse(_timeController.text) ?? 0;

    final rateDecimal = rate / 100;
    double result = 0;

    if (_calculationType == 'VA') {
      // Valor Actual
      if (rateDecimal == 0) {
        result = payment * time;
      } else {
        if (_annuityType == 'ordinary') {
          result = payment * (1 - pow(1 + rateDecimal, -time)) / rateDecimal;
        } else {
          result = payment *
              (1 - pow(1 + rateDecimal, -time)) /
              rateDecimal *
              (1 + rateDecimal);
        }
      }
    } else {
      // Valor Futuro
      if (rateDecimal == 0) {
        result = payment * time;
      } else {
        if (_annuityType == 'ordinary') {
          result = payment * (pow(1 + rateDecimal, time) - 1) / rateDecimal;
        } else {
          result = payment *
              (pow(1 + rateDecimal, time) - 1) /
              rateDecimal *
              (1 + rateDecimal);
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            'Resultado - ${_calculationType == 'VA' ? 'Valor Actual' : 'Valor Futuro'} (${_annuityType == 'ordinary' ? 'Vencida' : 'Anticipada'})'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pago periódico (A): \$${payment.toStringAsFixed(2)}'),
              Text('Tasa de interés (i): ${rate.toStringAsFixed(2)}%'),
              Text('Número de períodos (n): ${time.toStringAsFixed(0)}'),
              Text('Tipo de anualidad: ${_annuityType == 'ordinary' ? 'Vencida' : 'Anticipada'}'),
              SizedBox(height: 10),
              Text(
                  '${_calculationType == 'VA' ? 'Valor Actual' : 'Valor Futuro'}: \$${result.toStringAsFixed(2)}',
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
      title: Text('Anualidades'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _paymentController,
              decoration: InputDecoration(
                  labelText: 'Pago periódico (A)', hintText: 'Ej: 100'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _rateController,
              decoration: InputDecoration(
                  labelText: 'Tasa de interés por período (i) %',
                  hintText: 'Ej: 2.5'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                  labelText: 'Número de períodos (n)', hintText: 'Ej: 12'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            // Selección de tipo de anualidad
            DropdownButtonFormField(
              value: _annuityType,
              decoration: InputDecoration(labelText: 'Tipo de anualidad'),
              items: [
                DropdownMenuItem(value: 'ordinary', child: Text('Vencida')),
                DropdownMenuItem(value: 'due', child: Text('Anticipada')),
              ],
              onChanged: (value) {
                setState(() {
                  _annuityType = value.toString();
                });
              },
            ),
            SizedBox(height: 10),
            // Selección de qué calcular (VA o VF)
            DropdownButtonFormField(
              value: _calculationType,
              decoration: InputDecoration(labelText: 'Cálculo'),
              items: [
                DropdownMenuItem(value: 'VA', child: Text('Valor Actual (VA)')),
                DropdownMenuItem(value: 'VF', child: Text('Valor Futuro (VF)')),
              ],
              onChanged: (value) {
                setState(() {
                  _calculationType = value.toString();
                });
              },
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
          onPressed: () => _calculateAnnuity(context),
          child: Text('Calcular'),
        ),
      ],
    );
  }
}
