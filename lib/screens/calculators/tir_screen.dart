import 'package:flutter/material.dart';
import 'dart:math';
import '../../utils/constants.dart';
import '../../widgets/components/input_field.dart';
import '../../widgets/components/result_card.dart';

class TirScreen extends StatefulWidget {
  const TirScreen({super.key});

  @override
  _TirScreenState createState() => _TirScreenState();
}

class _TirScreenState extends State<TirScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _investmentController = TextEditingController();
  final List<TextEditingController> _cashFlowControllers = [
    TextEditingController()
  ];
  String _resultText = 'Realiza un cálculo para ver el resultado';
  double _resultValue = 0.0;

  // Función de validación para números
  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa $fieldName';
    }

    final numberRegex = RegExp(r'^-?\d*\.?\d*$'); // Permite negativos
    if (!numberRegex.hasMatch(value)) {
      return 'Ingresa solo números válidos';
    }

    final numericValue = double.tryParse(value);
    if (numericValue == null) {
      return 'Ingresa un valor válido';
    }

    return null;
  }

  // Agregar nuevo flujo de caja
  void _addCashFlow() {
    setState(() {
      _cashFlowControllers.add(TextEditingController());
    });
  }

  // Remover flujo de caja
  void _removeCashFlow(int index) {
    if (_cashFlowControllers.length > 1) {
      setState(() {
        _cashFlowControllers.removeAt(index);
      });
    }
  }

  // Calcular TIR usando método de aproximación (Newton-Raphson simplificado)
  double _calculateTIR(double investment, List<double> cashFlows) {
    // Método iterativo para encontrar la TIR
    double tir = 0.1; // Tasa inicial del 10%
    double precision = 0.0001; // Precisión de 0.01%
    int maxIterations = 100;

    for (int i = 0; i < maxIterations; i++) {
      double npv = _calculateNPV(investment, cashFlows, tir);
      double npvDerivative =
          _calculateNPVDerivative(investment, cashFlows, tir);

      if (npvDerivative.abs() < precision) break;

      double newTir = tir - npv / npvDerivative;

      if ((newTir - tir).abs() < precision) {
        return newTir;
      }

      tir = newTir;
    }

    return tir;
  }

  // Calcular VPN para una tasa dada
  double _calculateNPV(double investment, List<double> cashFlows, double rate) {
    double npv = -investment; // Inversión inicial (negativa)

    for (int i = 0; i < cashFlows.length; i++) {
      npv += cashFlows[i] / pow(1 + rate, i + 1);
    }

    return npv;
  }

  // Calcular derivada del VPN (para método Newton-Raphson)
  double _calculateNPVDerivative(
      double investment, List<double> cashFlows, double rate) {
    double derivative = 0;

    for (int i = 0; i < cashFlows.length; i++) {
      derivative -= (i + 1) * cashFlows[i] / pow(1 + rate, i + 2);
    }

    return derivative;
  }

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      double investment = double.parse(_investmentController.text);
      List<double> cashFlows = [];

      for (var controller in _cashFlowControllers) {
        if (controller.text.isNotEmpty) {
          cashFlows.add(double.parse(controller.text));
        }
      }

      // Validar que hay flujos de caja
      if (cashFlows.isEmpty) {
        setState(() {
          _resultText = 'Error: Debes ingresar al menos un flujo de caja';
          _resultValue = 0.0;
        });
        return;
      }

      try {
        double tir = _calculateTIR(investment, cashFlows);

        setState(() {
          _resultValue = tir * 100; // Convertir a porcentaje
          _resultText =
              'Tasa Interna de Retorno (TIR): ${_resultValue.toStringAsFixed(2)}%';
        });
      } catch (e) {
        setState(() {
          _resultText =
              'Error: No se pudo calcular la TIR. Verifica los datos.';
          _resultValue = 0.0;
        });
      }
    }
  }

  void _clearResults() {
    setState(() {
      _resultText = 'Realiza un cálculo para ver el resultado';
      _resultValue = 0.0;
      _investmentController.clear();
      for (var controller in _cashFlowControllers) {
        controller.clear();
      }
      // Mantener al menos un flujo de caja
      if (_cashFlowControllers.length > 1) {
        _cashFlowControllers
          ..clear()
          ..add(TextEditingController());
      }
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
          'TIR - Tasa Interna de Retorno',
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
              // Tarjeta informativa sobre TIR
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
                          Icons.auto_graph,
                          color: AppConstants.neonBlue,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tasa Interna de Retorno (TIR)',
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
                      'La TIR es la tasa de descuento que hace que el Valor Presente Neto (VPN) de todos los flujos de caja de un proyecto sea igual a cero. Es una métrica clave para evaluar la rentabilidad de inversiones.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fórmula: ∑[FCₜ / (1 + TIR)ᵗ] - Inversión Inicial = 0',
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
                        _buildVariableInfo('TIR', 'Tasa Interna de Retorno'),
                        _buildVariableInfo('FCₜ', 'Flujo de Caja período t'),
                        _buildVariableInfo('t', 'Número del período'),
                        _buildVariableInfo('VPN', 'Valor Presente Neto'),
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
                            Icons.lightbulb_outline,
                            color: Colors.orange,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Interpretación: TIR > Tasa de corte → Proyecto viable\nTIR < Tasa de corte → Proyecto no viable',
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
                'Calcula la tasa de descuento que hace que el Valor Presente Neto (VPN) de un proyecto sea igual a cero',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),

              SizedBox(height: 25),

              // Inversión inicial
              InputField(
                controller: _investmentController,
                label: 'Inversión Inicial (\$)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) =>
                    _validateNumber(value, 'la inversión inicial'),
              ),

              SizedBox(height: 20),

              // Flujos de caja
              _buildCashFlowsSection(),

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
                        'Calcular TIR',
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

  Widget _buildCashFlowsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Flujos de Caja por Período',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Ingresa los flujos de caja esperados para cada período (pueden ser positivos o negativos)',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 15),

        // Lista de flujos de caja
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _cashFlowControllers.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: InputField(
                      controller: _cashFlowControllers[index],
                      label: 'Flujo Período ${index + 1} (\$)',
                      icon: Icons.account_balance_wallet,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) =>
                          _validateNumber(value, 'el flujo de caja'),
                    ),
                  ),
                  SizedBox(width: 10),
                  if (_cashFlowControllers.length > 1)
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeCashFlow(index),
                      tooltip: 'Eliminar flujo',
                    ),
                ],
              ),
            );
          },
        ),

        // Botón para agregar más flujos
        SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _addCashFlow,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppConstants.neonBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: Icon(Icons.add, color: AppConstants.neonBlue, size: 18),
          label: Text(
            'Agregar Período',
            style: TextStyle(
              color: AppConstants.neonBlue,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _investmentController.dispose();
    for (var controller in _cashFlowControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
