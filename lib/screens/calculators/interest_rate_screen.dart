import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/time_selector.dart';
import '../../widgets/components/result_card.dart';

class InterestRateScreen extends StatefulWidget {
  const InterestRateScreen({super.key});

  @override
  _InterestRateScreenState createState() => _InterestRateScreenState();
}

class _InterestRateScreenState extends State<InterestRateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;

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
          'Tasa de Interés',
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
                'Calculadora para determinar la tasa de interés simple',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 25),

              // Campo Interés
              InputField(
                controller: _interestController,
                label: 'Interés (I)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateNumber(value, 'el interés'),
              ),

              SizedBox(height: 20),

              // Campo Capital
              InputField(
                controller: _capitalController,
                label: 'Capital (C)',
                icon: Icons.account_balance_wallet,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateNumber(value, 'el capital'),
              ),

              SizedBox(height: 20),

              // Selector de tiempo
              TimeSelector(
                yearsController: _yearsController,
                monthsController: _monthsController,
                daysController: _daysController,
                validator: (value) {
                  // Validar que al menos un campo de tiempo tenga valor
                  if (_yearsController.text.isEmpty &&
                      _monthsController.text.isEmpty &&
                      _daysController.text.isEmpty) {
                    return 'Ingresa al menos un valor de tiempo';
                  }
                  return null;
                },
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
                        'Calcular Tasa',
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
                      onPressed: _clearAllFields,
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

  // Función para convertir años, meses y días a años decimales
  double _convertTimeToYears() {
    double years =
        _yearsController.text.isEmpty ? 0 : double.parse(_yearsController.text);
    double months = _monthsController.text.isEmpty
        ? 0
        : double.parse(_monthsController.text);
    double days =
        _daysController.text.isEmpty ? 0 : double.parse(_daysController.text);

    return years + (months / 12) + (days / 360);
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double interest = double.parse(_interestController.text);
      double capital = double.parse(_capitalController.text);

      // Validar que capital no sea cero para evitar división por cero
      if (capital == 0) {
        setState(() {
          _resultText = 'Error: El capital no puede ser cero';
          _resultValue = 0.0;
        });
        return;
      }

      // Convertir tiempo a años decimales
      double timeInYears = _convertTimeToYears();

      // Validar que el tiempo no sea cero
      if (timeInYears == 0) {
        setState(() {
          _resultText = 'Error: El tiempo no puede ser cero';
          _resultValue = 0.0;
        });
        return;
      }

      // Fórmula: i = I / (C * t)
      double rate = (interest / (capital * timeInYears)) * 100;

      setState(() {
        _resultValue = rate;
        _resultText = 'Tasa de Interés (i): ${rate.toStringAsFixed(2)}%';
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      _resultText = 'Realiza un cálculo para ver el resultado';
      _resultValue = 0.0;
      _interestController.clear();
      _capitalController.clear();
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
    });
  }

  @override
  void dispose() {
    _capitalController.dispose();
    _interestController.dispose();
    _yearsController.dispose();
    _monthsController.dispose();
    _daysController.dispose();
    super.dispose();
  }
}
