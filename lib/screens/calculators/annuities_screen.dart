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
              // Tarjeta informativa sobre Anualidades
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
                          Icons.account_balance_wallet,
                          color: AppConstants.neonBlue,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '¿Qué son las Anualidades?',
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
                      'Una anualidad es una serie de pagos iguales realizados a intervalos regulares durante un período determinado. Se usa comúnmente en planes de ahorro, pensiones y créditos.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Valor Final: VF = A × [(1 + i)ⁿ - 1] / i',
                      style: TextStyle(
                        color: AppConstants.neonBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Valor Actual: VA = A × [1 - (1 + i)⁻ⁿ] / i',
                      style: TextStyle(
                        color: AppConstants.neonBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildVariableInfo('A', 'Anualidad (pago periódico)'),
                        _buildVariableInfo('i', 'Tasa de interés por periodo'),
                        _buildVariableInfo('n', 'Número de periodos'),
                        _buildVariableInfo('VF', 'Valor Futuro'),
                        _buildVariableInfo('VA', 'Valor Actual'),
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
                            Icons.timeline,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Valor Final: Monto acumulado al final de los periodos.\nValor Actual: Valor presente de los pagos futuros.',
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
