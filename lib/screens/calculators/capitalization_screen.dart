import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/time_selector.dart';
import '../../widgets/components/result_card.dart';

class CapitalizationScreen extends StatefulWidget {
  const CapitalizationScreen({super.key});

  @override
  _CapitalizationScreenState createState() => _CapitalizationScreenState();
}

class _CapitalizationScreenState extends State<CapitalizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  String _capitalizationType = 'Capitalización Simple';
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;

  List<String> capitalizationTypes = [
    'Capitalización Simple',
    'Capitalización Compuesta'
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
          'Capitalización',
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
              // Tarjeta informativa sobre Capitalización
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.secondaryDarkBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConstants.neonBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: AppConstants.neonBlue,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tipos de Capitalización',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'La capitalización determina cómo se calculan los intereses sobre una inversión o préstamo a lo largo del tiempo.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Información específica por tipo de capitalización
                    if (_capitalizationType == 'Capitalización Simple') ...[
                      Text(
                        'Capitalización Simple:',
                        style: TextStyle(
                          color: AppConstants.neonBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Interés calculado siempre sobre el capital inicial\n• Crecimiento lineal en el tiempo\n• Fórmula: M = C × (1 + i × n)',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Capitalización Compuesta:',
                        style: TextStyle(
                          color: AppConstants.neonBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Interés calculado sobre el capital acumulado\n• Crecimiento exponencial (interés sobre interés)\n• Fórmula: M = C × (1 + i)ⁿ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildVariableInfo('C', 'Capital inicial'),
                        _buildVariableInfo('i', 'Tasa de interés periódica'),
                        _buildVariableInfo('n', 'Tiempo en años'),
                        _buildVariableInfo('M', 'Monto futuro'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _capitalizationType == 'Capitalización Simple'
                                  ? 'Recomendada para períodos cortos y cálculos simples. Los intereses no generan más intereses.'
                                  : 'Ideal para inversiones a largo plazo. El "interés compuesto" acelera el crecimiento.',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // Descripción
              Text(
                'Calculadora para determinar el monto futuro con capitalización simple o compuesta',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 25),

              // Tipo de capitalización
              Text(
                'Tipo de capitalización',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _capitalizationType,
                dropdownColor: AppConstants.neonBlue,
                style: TextStyle(color: Colors.white),
                items: capitalizationTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child:
                              Text(type, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _capitalizationType = value!;
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
                    borderSide:
                        BorderSide(color: AppConstants.neonBlue, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),

              SizedBox(height: 25),

              // Campos de entrada
              InputField(
                controller: _capitalController,
                label: 'Capital Inicial (C)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    _validateNumber(value, 'el capital inicial'),
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

              // Selector de tiempo (igual que en Interés Simple)
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

              // Botones de acción - MISMOS COLORES QUE INTERÉS SIMPLE
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
                        'Calcular Monto',
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

  // Widget auxiliar para mostrar información de variables
  Widget _buildVariableInfo(String variable, String description) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppConstants.neonBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppConstants.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$variable: ',
              style: TextStyle(
                color: AppConstants.neonBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double capital = double.parse(_capitalController.text);
      double rate = double.parse(_rateController.text) / 100;
      double timeInYears = _convertTimeToYears();
      double resultValue = 0.0;
      String resultText = '';

      setState(() {
        if (_capitalizationType == 'Capitalización Simple') {
          // M = C * (1 + i * t)
          resultValue = capital * (1 + rate * timeInYears);
          resultText = 'Monto Futuro (M): \$${resultValue.toStringAsFixed(2)}';
        } else if (_capitalizationType == 'Capitalización Compuesta') {
          // M = C * (1 + i)^t
          resultValue = capital * pow(1 + rate, timeInYears);
          resultText = 'Monto Futuro (M): \$${resultValue.toStringAsFixed(2)}';
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
    });
  }

  @override
  void dispose() {
    _capitalController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    _monthsController.dispose();
    _daysController.dispose();
    super.dispose();
  }
}
