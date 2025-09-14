import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/time_selector.dart';
import '../../widgets/components/result_card.dart';

class SimpleInterestScreen extends StatefulWidget {
  const SimpleInterestScreen({super.key});

  @override
  _SimpleInterestScreenState createState() => _SimpleInterestScreenState();
}

class _SimpleInterestScreenState extends State<SimpleInterestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  String _calculationType = 'Interés Simple';
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;

  List<String> calculationTypes = [
    'Interés Simple',
    'Monto o Valor Futuro',
    'Valor Presente (Capital)',
    'Tasa de interés simple',
    'Tiempo necesario'
  ];

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

  // Función para convertir años decimales a años, meses y días
  Map<String, int> _convertYearsToTime(double yearsDecimal) {
    int years = yearsDecimal.floor();
    double remaining = yearsDecimal - years;

    int months = (remaining * 12).floor();
    remaining = (remaining * 12) - months;

    int days = (remaining * 30).round();

    if (days >= 30) {
      months += 1;
      days = 0;
    }

    if (months >= 12) {
      years += 1;
      months = months - 12;
    }

    return {'years': years, 'months': months, 'days': days};
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double capital = _capitalController.text.isEmpty
          ? 0
          : double.parse(_capitalController.text);
      double rate = _rateController.text.isEmpty
          ? 0
          : double.parse(_rateController.text) / 100;
      double interest = _interestController.text.isEmpty
          ? 0
          : double.parse(_interestController.text);
      double resultValue = 0.0;
      String resultText = '';

      double timeInYears = _convertTimeToYears();

      setState(() {
        if (_calculationType == 'Interés Simple') {
          resultValue = capital * rate * timeInYears;
          resultText =
              'Interés Simple (I): \$${resultValue.toStringAsFixed(2)}';
        } else if (_calculationType == 'Monto o Valor Futuro') {
          resultValue = capital * (1 + rate * timeInYears);
          resultText = 'Monto Futuro (VF): \$${resultValue.toStringAsFixed(2)}';
        } else if (_calculationType == 'Valor Presente (Capital)') {
          resultValue = interest / (rate * timeInYears);
          resultText =
              'Valor Presente (C): \$${resultValue.toStringAsFixed(2)}';
        } else if (_calculationType == 'Tasa de interés simple') {
          resultValue = (interest / (capital * timeInYears)) * 100;
          resultText =
              'Tasa de Interés (i): ${resultValue.toStringAsFixed(2)}%';
        } else if (_calculationType == 'Tiempo necesario') {
          double timeDecimal = interest / (capital * rate);
          Map<String, int> timeComponents = _convertYearsToTime(timeDecimal);
          resultText = 'Tiempo necesario: '
              '${timeComponents['years']} años, '
              '${timeComponents['months']} meses, '
              '${timeComponents['days']} días';
          resultValue = timeDecimal;
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
      _capitalController.clear();
      _rateController.clear();
      _yearsController.clear();
      _monthsController.clear();
      _daysController.clear();
      _interestController.clear();
    });
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
          'Interés Simple',
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
                'Calculadora para determinar interés simple, monto futuro, valor presente, tasa de interés o tiempo necesario',
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

              // Campos específicos según el tipo de cálculo
              _buildInputFields(),

              SizedBox(height: 30),

              // Botones de acción - COLORES ACTUALIZADOS
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
                        side: BorderSide(
                            color: AppConstants.neonBlue), // Mismo azul
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

  Widget _buildInputFields() {
    return Column(
      children: [
        // Campos para INTERÉS SIMPLE y MONTO FUTURO
        if (_calculationType == 'Interés Simple' ||
            _calculationType == 'Monto o Valor Futuro' ||
            _calculationType == 'Tasa de interés simple' ||
            _calculationType == 'Tiempo necesario')
          InputField(
            controller: _capitalController,
            label: 'Capital (C)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el capital'),
          ),

        if (_calculationType == 'Interés Simple' ||
            _calculationType == 'Monto o Valor Futuro' ||
            _calculationType == 'Valor Presente (Capital)' ||
            _calculationType == 'Tiempo necesario')
          SizedBox(height: 20),

        if (_calculationType == 'Interés Simple' ||
            _calculationType == 'Monto o Valor Futuro' ||
            _calculationType == 'Valor Presente (Capital)' ||
            _calculationType == 'Tiempo necesario')
          InputField(
            controller: _rateController,
            label: 'Tasa de Interés (i) %',
            icon: Icons.percent,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'la tasa de interés'),
          ),

        if (_calculationType == 'Valor Presente (Capital)' ||
            _calculationType == 'Tasa de interés simple' ||
            _calculationType == 'Tiempo necesario')
          SizedBox(height: 20),

        if (_calculationType == 'Valor Presente (Capital)' ||
            _calculationType == 'Tasa de interés simple' ||
            _calculationType == 'Tiempo necesario')
          InputField(
            controller: _interestController,
            label: 'Interés (I)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el interés'),
          ),

        // Selector de tiempo para todos excepto "Tiempo necesario"
        if (_calculationType != 'Tiempo necesario') ...[
          SizedBox(height: 20),
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
        ],
      ],
    );
  }

  @override
  void dispose() {
    _capitalController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    _monthsController.dispose();
    _daysController.dispose();
    _interestController.dispose();
    super.dispose();
  }
}
