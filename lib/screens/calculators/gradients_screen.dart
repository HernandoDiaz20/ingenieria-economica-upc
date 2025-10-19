import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/result_card.dart';

class GradientsScreen extends StatefulWidget {
  const GradientsScreen({super.key});

  @override
  _GradientsScreenState createState() => _GradientsScreenState();
}

class _GradientsScreenState extends State<GradientsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstFlowController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _periodsController = TextEditingController();
  final TextEditingController _gradientController = TextEditingController();
  String _gradientType = 'Aritmético';
  String _calculationType = 'Valor Presente';
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;

  List<String> gradientTypes = ['Aritmético', 'Geométrico'];
  List<String> calculationTypes = ['Valor Presente', 'Valor Futuro'];

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
          'Gradientes y Series Variables',
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
              // Tarjeta informativa sobre Gradientes
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
                          '¿Qué son los Gradientes?',
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
                      'Los gradientes son series de flujos de efectivo que aumentan o disminuyen en cada período según un patrón específico. Se usan para modelar ingresos o costos que cambian sistemáticamente.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Información específica por tipo de gradiente
                    if (_gradientType == 'Aritmético') ...[
                      Text(
                        'Gradiente Aritmético:',
                        style: TextStyle(
                          color: AppConstants.neonBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Incremento constante en cada período\n• Fórmula VP: A × [(1 - (1+i)⁻ⁿ)/i] + (G/i) × [(1 - (1+i)⁻ⁿ)/i - n×(1+i)⁻ⁿ]\n• El primer flujo NO incluye el incremento',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Gradiente Geométrico:',
                        style: TextStyle(
                          color: AppConstants.neonBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Incremento porcentual constante en cada período\n• Fórmula VP: A₁ × [1 - (1+g)ⁿ(1+i)⁻ⁿ] / (i - g)\n• Cuando i = g: VP = A₁ × [n / (1+i)]',
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
                        _buildVariableInfo('A, A₁', 'Primer flujo de caja'),
                        _buildVariableInfo('i', 'Tasa de interés periódica'),
                        _buildVariableInfo('n', 'Número de periodos'),
                        _buildVariableInfo(
                            'G', 'Incremento constante (Aritmético)'),
                        _buildVariableInfo(
                            'g', 'Tasa crecimiento % (Geométrico)'),
                        _buildVariableInfo('VP', 'Valor Presente'),
                        _buildVariableInfo('VF', 'Valor Futuro'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _gradientType == 'Aritmético'
                                  ? 'En gradiente aritmético: El primer flujo base NO incluye el incremento constante G.'
                                  : 'En gradiente geométrico: La tasa de crecimiento g se ingresa en porcentaje.',
                              style: TextStyle(
                                color: Colors.orange,
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
                'Calculadora para determinar el valor presente o futuro de series variables con crecimiento aritmético o geométrico',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 25),

              // Tipo de gradiente
              Text(
                'Tipo de Gradiente',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _gradientType,
                dropdownColor: AppConstants.neonBlue,
                style: TextStyle(color: Colors.white),
                items: gradientTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child:
                              Text(type, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _gradientType = value!;
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

              SizedBox(height: 20),

              // Tipo de cálculo
              Text(
                'Tipo de Cálculo',
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
                controller: _firstFlowController,
                label: _gradientType == 'Aritmético'
                    ? 'Primer Flujo (A)'
                    : 'Flujo Inicial (A₁)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _validateNumber(value, 'el primer flujo'),
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

              SizedBox(height: 20),

              InputField(
                controller: _gradientController,
                label: _gradientType == 'Aritmético'
                    ? 'Incremento Constante (G)'
                    : 'Tasa Crecimiento (g) %',
                icon: _gradientType == 'Aritmético'
                    ? Icons.trending_up
                    : Icons.percent,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) => _gradientType == 'Aritmético'
                    ? _validateNumber(value, 'el incremento constante')
                    : _validateNumber(value, 'la tasa de crecimiento'),
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
      double firstFlow = double.parse(_firstFlowController.text);
      double rate = double.parse(_rateController.text) / 100;
      int periods = int.parse(_periodsController.text);
      double gradientValue = double.parse(_gradientController.text);
      double resultValue = 0.0;
      String resultText = '';

      setState(() {
        if (_gradientType == 'Aritmético') {
          // GRADIENTE ARITMÉTICO - FÓRMULA CORREGIDA
          if (_calculationType == 'Valor Presente') {
            // Fórmula exacta del ejemplo: VP = A * [(1 - (1+i)^-n)/i] + (G/i) * [(1 - (1+i)^-n)/i - n*(1+i)^-n]
            double uniformPart =
                firstFlow * ((1 - pow(1 + rate, -periods)) / rate);
            double gradientPart = (gradientValue / rate) *
                (((1 - pow(1 + rate, -periods)) / rate) -
                    periods * pow(1 + rate, -periods));

            resultValue = uniformPart + gradientPart;
            resultText =
                'Valor Presente (VP): \$${resultValue.toStringAsFixed(2)}';
          } else {
            // Valor Futuro para Gradiente Aritmético
            // VF = A * [((1+i)^n - 1)/i] + (G/i) * [((1+i)^n - 1)/i - n]
            double uniformPart =
                firstFlow * ((pow(1 + rate, periods) - 1) / rate);
            double gradientPart = (gradientValue / rate) *
                (((pow(1 + rate, periods) - 1) / rate) - periods);

            resultValue = uniformPart + gradientPart;
            resultText =
                'Valor Futuro (VF): \$${resultValue.toStringAsFixed(2)}';
          }
        } else {
          // GRADIENTE GEOMÉTRICO
          double growthRate = gradientValue / 100;

          if (_calculationType == 'Valor Presente') {
            if (rate == growthRate) {
              // Caso especial: i = g
              resultValue = firstFlow * (periods / (1 + rate));
              resultText =
                  'Valor Presente (VP): \$${resultValue.toStringAsFixed(2)}';
            } else {
              // Caso general: i ≠ g
              // VP = A₁ * [1 - (1+g)ⁿ(1+i)⁻ⁿ] / (i - g)
              try {
                double term1 = pow(1 + growthRate, periods).toDouble();
                double term2 = pow(1 + rate, -periods).toDouble();
                double numerator = 1 - (term1 * term2);
                resultValue = firstFlow * (numerator / (rate - growthRate));
                resultText =
                    'Valor Presente (VP): \$${resultValue.toStringAsFixed(2)}';
              } catch (e) {
                resultText =
                    'Error en el cálculo. Verifica los valores ingresados.';
                resultValue = 0.0;
              }
            }
          } else {
            // Valor Futuro para geométrico
            // VF = VP * (1+i)^n
            double presentValue;
            if (rate == growthRate) {
              presentValue = firstFlow * (periods / (1 + rate));
            } else {
              try {
                double term1 = pow(1 + growthRate, periods).toDouble();
                double term2 = pow(1 + rate, -periods).toDouble();
                double numerator = 1 - (term1 * term2);
                presentValue = firstFlow * (numerator / (rate - growthRate));
              } catch (e) {
                resultText =
                    'Error en el cálculo. Verifica los valores ingresados.';
                resultValue = 0.0;
                _resultValue = resultValue;
                _resultText = resultText;
                return;
              }
            }
            resultValue = presentValue * pow(1 + rate, periods).toDouble();
            resultText =
                'Valor Futuro (VF): \$${resultValue.toStringAsFixed(2)}';
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
      _firstFlowController.clear();
      _rateController.clear();
      _periodsController.clear();
      _gradientController.clear();
    });
  }

  @override
  void dispose() {
    _firstFlowController.dispose();
    _rateController.dispose();
    _periodsController.dispose();
    _gradientController.dispose();
    super.dispose();
  }
}
