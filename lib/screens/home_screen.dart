import 'package:flutter/material.dart';
import '../widgets/calculator_button.dart';
import '../widgets/dialogs/simple_interest_dialog.dart';
import '../widgets/dialogs/compound_interest_dialog.dart';
import '../widgets/dialogs/interest_rate_dialog.dart';
import '../widgets/dialogs/annuities_dialog.dart';

class HomeScreen extends StatelessWidget {
  void _showInterestRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InterestRateDialog(),
    );
  }

  void _showSimpleInterestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleInterestDialog(),
    );
  }

  void _showCompoundInterestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CompoundInterestDialog(),
    );
  }

  void _showAnnuitiesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AnnuitiesDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingeniería Económica'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Unidad I - Conceptos Básicos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  CalculatorButton(
                    title: 'Tasa de Interés',
                    icon: Icons.trending_up,
                    color: Colors.blue,
                    onPressed: () => _showInterestRateDialog(context),
                  ),
                  CalculatorButton(
                    title: 'Interés Simple',
                    icon: Icons.calculate,
                    color: Colors.green,
                    onPressed: () => _showSimpleInterestDialog(context),
                  ),
                  CalculatorButton(
                    title: 'Interés Compuesto',
                    icon: Icons.auto_graph,
                    color: Colors.orange,
                    onPressed: () => _showCompoundInterestDialog(context),
                  ),
                  CalculatorButton(
                    title: 'Anualidades',
                    icon: Icons.pie_chart,
                    color: Colors.purple,
                    onPressed: () => _showAnnuitiesDialog(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
