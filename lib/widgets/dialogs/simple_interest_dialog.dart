import 'package:flutter/material.dart';
import 'dart:math';

class SimpleInterestDialog extends StatefulWidget {
  @override
  _SimpleInterestDialogState createState() => _SimpleInterestDialogState();
}

class _SimpleInterestDialogState extends State<SimpleInterestDialog> {
  final _capitalController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeController = TextEditingController();
  final _interestController = TextEditingController(); // Para casos donde ya conozco I

  String _selectedType = "Simple"; // "Simple" o "Compuesto"
  String _selectedSimpleCalc = "Interés (I)"; // Por defecto dentro de Simple

  @override
  void dispose() {
    _capitalController.dispose();
    _rateController.dispose();
    _timeController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  void _calculateInterest(BuildContext context) {
    final capital = double.tryParse(_capitalController.text.replaceAll(',', '.')) ?? 0;
    final rate = double.tryParse(_rateController.text.replaceAll(',', '.')) ?? 0;
    final time = double.tryParse(_timeController.text.replaceAll(',', '.')) ?? 0;
    final interestInput = double.tryParse(_interestController.text.replaceAll(',', '.')) ?? 0;

    double result = 0;
    String title = "";

    if (_selectedType == "Simple") {
      switch (_selectedSimpleCalc) {
        case "Interés (I)": // I = C * i * t
          result = capital * (rate / 100) * time;
          title = "Interés Simple (I)";
          break;
        case "Monto (M)": // M = C (1 + i*t)
          result = capital * (1 + (rate / 100) * time);
          title = "Monto con Interés Simple (M)";
          break;
        case "Capital (C)": // C = I / (i*t)
          if (rate == 0 || time == 0) {
            _showError(context, "La tasa y el tiempo deben ser mayores que 0.");
            return;
          }
          result = interestInput / ((rate / 100) * time);
          title = "Capital (C)";
          break;
        case "Tasa (i)": // i = I / (C*t)
          if (capital == 0 || time == 0) {
            _showError(context, "El capital y el tiempo deben ser mayores que 0.");
            return;
          }
          result = (interestInput / (capital * time)) * 100; // en porcentaje
          title = "Tasa de interés (i %)";
          break;
        case "Tiempo (t)": // t = I / (C*i)
          if (capital == 0 || rate == 0) {
            _showError(context, "El capital y la tasa deben ser mayores que 0.");
            return;
          }
          result = interestInput / (capital * (rate / 100));
          title = "Tiempo (t)";
          break;
      }
    } else {
      // Interés Compuesto: M = C * (1 + i)^t ; I = M - C
      final total = capital * pow(1 + rate / 100, time);
      final interest = total - capital;
      title = "Interés Compuesto";
      _showResult(context, title, {
        "Capital (C)": capital,
        "Tasa (i)": rate,
        "Tiempo (t)": time,
        "Interés (I)": interest,
        "Monto (M)": total,
      });
      return;
    }

    _showResult(context, title, {title: result});
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  void _showResult(BuildContext context, String title, Map<String, double> values) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: values.entries.map((e) {
            return Text("${e.key}: ${_formatNumber(e.value)}");
          }).toList(),
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

  String _formatNumber(double value) {
    if (value % 1 == 0) {
      return value.toStringAsFixed(0);
    } else {
      return value.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSimple = _selectedType == "Simple";

    return AlertDialog(
      title: Text('Calculadora de Interés'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primer dropdown: Simple o Compuesto
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(labelText: "Tipo de interés"),
              items: ["Simple", "Compuesto"]
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),

            // Segundo dropdown: qué calcular dentro de Simple
            if (isSimple)
              DropdownButtonFormField<String>(
                value: _selectedSimpleCalc,
                decoration: InputDecoration(labelText: "¿Qué deseas calcular?"),
                items: [
                  "Interés (I)",
                  "Monto (M)",
                  "Capital (C)",
                  "Tasa (i)",
                  "Tiempo (t)"
                ]
                    .map((calc) => DropdownMenuItem(value: calc, child: Text(calc)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSimpleCalc = value!;
                  });
                },
              ),

            SizedBox(height: 12),

            // Campos comunes
            TextField(
              controller: _capitalController,
              decoration: InputDecoration(labelText: 'Capital (C)', hintText: 'Ej: 1000'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _rateController,
              decoration: InputDecoration(labelText: 'Tasa (i) %', hintText: 'Ej: 5'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Tiempo (t)', hintText: 'Ej: 2'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),

            // Campo adicional: interés (solo si el cálculo lo requiere)
            if (isSimple &&
                (_selectedSimpleCalc == "Capital (C)" ||
                    _selectedSimpleCalc == "Tasa (i)" ||
                    _selectedSimpleCalc == "Tiempo (t)"))
              TextField(
                controller: _interestController,
                decoration: InputDecoration(labelText: 'Interés (I)', hintText: 'Ej: 970'),
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
