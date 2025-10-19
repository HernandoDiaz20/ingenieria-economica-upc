import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/result_card.dart';

class AmortizationScreen extends StatefulWidget {
  const AmortizationScreen({super.key});

  @override
  _AmortizationScreenState createState() => _AmortizationScreenState();
}

class _AmortizationScreenState extends State<AmortizationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _periodsController = TextEditingController();
  String _systemType = 'Sistema Francés';
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;
  List<Map<String, dynamic>> _amortizationTable = [];

  List<String> systemTypes = [
    'Sistema Francés',
    'Sistema Alemán',
    'Sistema Americano'
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
          'Sistemas de Amortización',
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
              // Tarjeta informativa sobre Sistemas de Amortización
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
                          Icons.account_balance,
                          color: AppConstants.neonBlue,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '¿Qué son los Sistemas de Amortización?',
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
                      'Los sistemas de amortización definen cómo se distribuyen los pagos de un préstamo a lo largo del tiempo, incluyendo capital e intereses.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Información específica por sistema
                    if (_systemType == 'Sistema Francés') ...[
                      Text(
                        'Sistema Francés (Cuotas Fijas):',
                        style: TextStyle(
                          color: AppConstants.neonBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Cuotas constantes durante todo el plazo\n• Intereses decrecientes y amortización creciente\n• Fórmula: A = P × [i(1+i)ⁿ] / [(1+i)ⁿ - 1]',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ] else if (_systemType == 'Sistema Alemán') ...[
                      Text(
                        'Sistema Alemán (Amortización Constante):',
                        style: TextStyle(
                          color: AppConstants.neonBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Amortización de capital constante\n• Cuotas totales decrecientes\n• Menor costo total en intereses\n• Fórmula: Amortización = P / n',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ] else ...[
                      Text(
                        'Sistema Americano (Pago Único Final):',
                        style: TextStyle(
                          color: AppConstants.neonBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Solo pagos de intereses periódicos\n• Capital se paga íntegro al final\n• Útil para inversiones a corto plazo\n• Fórmula: Pagos Periódicos = P × i',
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
                        _buildVariableInfo('P', 'Capital o Principal'),
                        _buildVariableInfo('i', 'Tasa de interés periódica'),
                        _buildVariableInfo('n', 'Número de periodos'),
                        _buildVariableInfo('A', 'Cuota periódica'),
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
                            Icons.compare_arrows,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _systemType == 'Sistema Francés'
                                  ? 'Recomendado para préstamos personales e hipotecarios por cuotas predecibles.'
                                  : _systemType == 'Sistema Alemán'
                                      ? 'Ideal cuando se busca menor costo total en intereses.'
                                      : 'Adecuado para proyectos con flujo inicial limitado pero ingreso futuro seguro.',
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
                'Calculadora para determinar cuotas según diferentes sistemas de amortización',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 25),

              // Tipo de sistema
              Text(
                'Sistema de Amortización',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _systemType,
                dropdownColor: AppConstants.neonBlue,
                style: TextStyle(color: Colors.white),
                items: systemTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child:
                              Text(type, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _systemType = value!;
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
                controller: _capitalController,
                label: 'Capital (P)',
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

              // Resultado principal
              ResultCard(
                resultText: _resultText,
                resultValue: _resultValue,
              ),

              SizedBox(height: 20),

              // Tabla de amortización (si existe)
              if (_amortizationTable.isNotEmpty) _buildAmortizationTable(),
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

  Widget _buildAmortizationTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tabla de Amortización',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            dataRowMinHeight: 40,
            dataRowMaxHeight: 40,
            headingTextStyle: TextStyle(
              color: AppConstants.neonBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            dataTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            columns: [
              DataColumn(label: Text('Período')),
              DataColumn(label: Text('Saldo Inicial')),
              DataColumn(label: Text('Cuota')),
              DataColumn(label: Text('Intereses')),
              DataColumn(label: Text('Amortización')),
              DataColumn(label: Text('Saldo Final')),
            ],
            rows: _amortizationTable.map((row) {
              return DataRow(cells: [
                DataCell(Text(row['period'].toString())),
                DataCell(Text('\$${row['initialBalance'].toStringAsFixed(2)}')),
                DataCell(Text('\$${row['payment'].toStringAsFixed(2)}')),
                DataCell(Text('\$${row['interest'].toStringAsFixed(2)}')),
                DataCell(Text('\$${row['amortization'].toStringAsFixed(2)}')),
                DataCell(Text('\$${row['finalBalance'].toStringAsFixed(2)}')),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double capital = double.parse(_capitalController.text);
      double rate = double.parse(_rateController.text) / 100;
      int periods = int.parse(_periodsController.text);
      double resultValue = 0.0;
      String resultText = '';
      List<Map<String, dynamic>> table = [];

      setState(() {
        if (_systemType == 'Sistema Francés') {
          // Fórmula: A = P × [i(1+i)ⁿ] / [(1+i)ⁿ - 1]
          double numerator = rate * pow(1 + rate, periods);
          double denominator = pow(1 + rate, periods) - 1;
          resultValue = capital * (numerator / denominator);
          resultText =
              'Cuota Fija: \$${resultValue.toStringAsFixed(2)} por período';

          // Generar tabla de amortización
          double balance = capital;
          for (int i = 1; i <= periods; i++) {
            double interest = balance * rate;
            double amortization = resultValue - interest;
            double finalBalance = balance - amortization;

            table.add({
              'period': i,
              'initialBalance': balance,
              'payment': resultValue,
              'interest': interest,
              'amortization': amortization,
              'finalBalance': finalBalance,
            });

            balance = finalBalance;
          }
        } else if (_systemType == 'Sistema Alemán') {
          // Amortización constante
          double amortization = capital / periods;
          resultValue = amortization + (capital * rate); // Primera cuota
          resultText =
              'Primera Cuota: \$${resultValue.toStringAsFixed(2)} (Cuotas decrecientes)';

          // Generar tabla de amortización
          double balance = capital;
          for (int i = 1; i <= periods; i++) {
            double interest = balance * rate;
            double payment = amortization + interest;
            double finalBalance = balance - amortization;

            table.add({
              'period': i,
              'initialBalance': balance,
              'payment': payment,
              'interest': interest,
              'amortization': amortization,
              'finalBalance': finalBalance,
            });

            balance = finalBalance;
          }
        } else if (_systemType == 'Sistema Americano') {
          // Solo intereses periódicos + capital al final
          double periodicPayment = capital * rate;
          double finalPayment = capital + periodicPayment;
          resultValue = periodicPayment;
          resultText =
              'Pago Periódico: \$${resultValue.toStringAsFixed(2)} (solo intereses) - Pago Final: \$${finalPayment.toStringAsFixed(2)}';

          // Generar tabla de amortización
          double balance = capital;
          for (int i = 1; i <= periods; i++) {
            double interest = balance * rate;
            double payment = (i == periods) ? capital + interest : interest;
            double amortization = (i == periods) ? capital : 0;
            double finalBalance = balance - amortization;

            table.add({
              'period': i,
              'initialBalance': balance,
              'payment': payment,
              'interest': interest,
              'amortization': amortization,
              'finalBalance': finalBalance,
            });

            balance = finalBalance;
          }
        }

        _resultValue = resultValue;
        _resultText = resultText;
        _amortizationTable = table;
      });
    }
  }

  void _clearResults() {
    setState(() {
      _resultText = 'Realiza un cálculo para ver el resultado';
      _resultValue = 0.0;
      _amortizationTable = [];
      _capitalController.clear();
      _rateController.clear();
      _periodsController.clear();
    });
  }

  @override
  void dispose() {
    _capitalController.dispose();
    _rateController.dispose();
    _periodsController.dispose();
    super.dispose();
  }
}
