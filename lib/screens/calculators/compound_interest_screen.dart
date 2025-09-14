import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/result_card.dart';

class CompoundInterestScreen extends StatefulWidget {
  const CompoundInterestScreen({super.key});

  @override
  _CompoundInterestScreenState createState() => _CompoundInterestScreenState();
}

class _CompoundInterestScreenState extends State<CompoundInterestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _periodsController = TextEditingController();
  final TextEditingController _compoundAmountController =
      TextEditingController();
  String _calculationType = 'Interés Compuesto';
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;

  List<String> calculationTypes = [
    'Interés Compuesto',
    'Monto Compuesto',
    'Capital',
    'Tasa de interés compuesto',
    'Tiempo Necesario'
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
          'Interés Compuesto',
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
                'Calculadora para determinar interés compuesto, monto compuesto, capital, tasa de interés o tiempo necesario',
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

  Widget _buildInputFields() {
    return Column(
      children: [
        // Campos para INTERÉS COMPUESTO
        if (_calculationType == 'Interés Compuesto') ...[
          InputField(
            controller: _compoundAmountController,
            label: 'Monto Compuesto (MC)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el monto compuesto'),
          ),
          SizedBox(height: 20),
          InputField(
            controller: _capitalController,
            label: 'Capital (C)',
            icon: Icons.account_balance_wallet,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el capital'),
          ),
        ],

        // Campos para MONTO COMPUESTO
        if (_calculationType == 'Monto Compuesto') ...[
          InputField(
            controller: _capitalController,
            label: 'Capital (C)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el capital'),
          ),
          SizedBox(height: 20),
          InputField(
            controller: _rateController,
            label: 'Tasa de Interés (i) %',
            icon: Icons.percent,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'la tasa de interés'),
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
        ],

        // Campos para CAPITAL
        if (_calculationType == 'Capital') ...[
          InputField(
            controller: _compoundAmountController,
            label: 'Monto Compuesto (MC)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el monto compuesto'),
          ),
          SizedBox(height: 20),
          InputField(
            controller: _rateController,
            label: 'Tasa de Interés (i) %',
            icon: Icons.percent,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'la tasa de interés'),
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
        ],

        // Campos para TASA DE INTERÉS COMPUESTO
        if (_calculationType == 'Tasa de interés compuesto') ...[
          InputField(
            controller: _compoundAmountController,
            label: 'Monto Compuesto (MC)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el monto compuesto'),
          ),
          SizedBox(height: 20),
          InputField(
            controller: _capitalController,
            label: 'Capital (C)',
            icon: Icons.account_balance_wallet,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el capital'),
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
        ],

        // Campos para TIEMPO NECESARIO
        if (_calculationType == 'Tiempo Necesario') ...[
          InputField(
            controller: _compoundAmountController,
            label: 'Monto Compuesto (MC)',
            icon: Icons.attach_money,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el monto compuesto'),
          ),
          SizedBox(height: 20),
          InputField(
            controller: _capitalController,
            label: 'Capital (C)',
            icon: Icons.account_balance_wallet,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'el capital'),
          ),
          SizedBox(height: 20),
          InputField(
            controller: _rateController,
            label: 'Tasa de Interés (i) %',
            icon: Icons.percent,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) => _validateNumber(value, 'la tasa de interés'),
          ),
        ],
      ],
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double capital = _capitalController.text.isEmpty
          ? 0
          : double.parse(_capitalController.text);
      double rate = _rateController.text.isEmpty
          ? 0
          : double.parse(_rateController.text) / 100;
      int periods = _periodsController.text.isEmpty
          ? 0
          : int.parse(_periodsController.text);
      double compoundAmount = _compoundAmountController.text.isEmpty
          ? 0
          : double.parse(_compoundAmountController.text);
      double resultValue = 0.0;
      String resultText = '';

      setState(() {
        if (_calculationType == 'Interés Compuesto') {
          // IC = MC - C
          resultValue = compoundAmount - capital;
          resultText =
              'Interés Compuesto (IC): \$${resultValue.toStringAsFixed(2)}';
        } else if (_calculationType == 'Monto Compuesto') {
          // MC = C * (1 + i)^n
          resultValue = capital * pow(1 + rate, periods);
          resultText =
              'Monto Compuesto (MC): \$${resultValue.toStringAsFixed(2)}';
        } else if (_calculationType == 'Capital') {
          // C = MC / (1 + i)^n
          resultValue = compoundAmount / pow(1 + rate, periods);
          resultText = 'Capital (C): \$${resultValue.toStringAsFixed(2)}';
        } else if (_calculationType == 'Tasa de interés compuesto') {
          // i = ((MC/C)^(1/n))-1
          resultValue = (pow(compoundAmount / capital, 1 / periods) - 1) * 100;
          resultText =
              'Tasa de Interés (i): ${resultValue.toStringAsFixed(2)}%';
        } else if (_calculationType == 'Tiempo Necesario') {
          // N = Log MC - Log C / Log (1+i)
          resultValue = (log(compoundAmount) - log(capital)) / log(1 + rate);
          resultText =
              'Tiempo Necesario (n): ${resultValue.toStringAsFixed(2)} periodos';
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
      _periodsController.clear();
      _compoundAmountController.clear();
    });
  }

  @override
  void dispose() {
    _capitalController.dispose();
    _rateController.dispose();
    _periodsController.dispose();
    _compoundAmountController.dispose();
    super.dispose();
  }
}
