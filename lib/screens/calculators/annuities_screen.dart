import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/result_card.dart';

class AnnuitiesScreen extends StatefulWidget {
  const AnnuitiesScreen({super.key});

  @override
  _AnnuitiesScreenState createState() => _AnnuitiesScreenState();
}

class _AnnuitiesScreenState extends State<AnnuitiesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _annuityController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _periodsController = TextEditingController();
  String _calculationType = 'Valor Final';
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;

  List<String> calculationTypes = ['Valor Final', 'Valor Actual'];

  // Función de validación para números
  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $fieldName';
    }

    final numberRegex = RegExp(r'^\d*\.?\d*$');
    if (!numberRegex.hasMatch(value)) {
      return 'Ingresa solo números válidos';
    }

    if (value.startsWith('-')) {
      return 'No se permiten valores negativos';
    }

    final numericValue = double.tryParse(value);
    if (numericValue == null || numericValue < 0) {
      return 'Ingresa un valor válido mayor o igual a 0';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryDarkBlue,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Anualidades',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Descripción
              Text(
                'Calculadora para determinar el valor final o valor actual de una anualidad',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 25),

              // Tipo de cálculo
              Text(
                'Tipo de cálculo',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _calculationType,
                dropdownColor: AppConstants.neonBlue,
                style: TextStyle(color: Colors.white),
                items: calculationTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child:
                              Text(type, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _calculationType = value!;
                    _clearResults();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF0F4C75), width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),

              SizedBox(height: 25),

              // Campos de entrada
              InputField(
                controller: _annuityController,
                label: 'Anualidad (A)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateNumber(value, 'la anualidad'),
              ),

              SizedBox(height: 20),

              InputField(
                controller: _rateController,
                label: 'Tasa de Interés (i) %',
                icon: Icons.percent,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    _validateNumber(value, 'la tasa de interés'),
              ),

              SizedBox(height: 20),

              InputField(
                controller: _periodsController,
                label: 'Número de Periodos (n)',
                icon: Icons.format_list_numbered,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    _validateNumber(value, 'el número de periodos'),
              ),

              SizedBox(height: 30),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.neonBlue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Calcular',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearResults,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppConstants.neonBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Limpiar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppConstants.neonBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // Resultado
              ResultCard(
                resultText: _resultText,
                resultValue: _resultValue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double annuity = double.parse(_annuityController.text);
      double rate = double.parse(_rateController.text) / 100;
      int periods = int.parse(_periodsController.text);
      double resultValue = 0.0;
      String resultText = '';

      setState(() {
        if (_calculationType == 'Valor Final') {
          // VF = A * (((1 + i)^n - 1) / i)
          if (rate == 0) {
            resultValue = annuity * periods;
            resultText =
                'Valor Final (VF): \$${resultValue.toStringAsFixed(2)}';
          } else {
            resultValue = annuity * ((pow(1 + rate, periods) - 1) / rate);
            resultText =
                'Valor Final (VF): \$${resultValue.toStringAsFixed(2)}';
          }
        } else if (_calculationType == 'Valor Actual') {
          // VA = A * ((1 - (1 + i)^-n) / i)
          if (rate == 0) {
            resultValue = annuity * periods;
            resultText =
                'Valor Actual (VA): \$${resultValue.toStringAsFixed(2)}';
          } else {
            resultValue = annuity * ((1 - pow(1 + rate, -periods)) / rate);
            resultText =
                'Valor Actual (VA): \$${resultValue.toStringAsFixed(2)}';
          }
        }

        _resultValue = resultValue;
        _resultText = resultText;
      });
    }
  }

  void _clearResults() {
    setState(() {
      _resultText = 'Realiza un cálculo para ver el resultado';
      _resultValue = 0.0;
      _annuityController.clear();
      _rateController.clear();
      _periodsController.clear();
    });
  }

  @override
  void dispose() {
    _annuityController.dispose();
    _rateController.dispose();
    _periodsController.dispose();
    super.dispose();
  }
}
