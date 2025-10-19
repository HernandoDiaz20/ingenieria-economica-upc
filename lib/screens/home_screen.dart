import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/calculator_button.dart';

class HomeScreen extends StatelessWidget {
  void _logout(BuildContext context) {
    AuthService.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    // Obtener nombre del usuario actual
    final userName = AuthService.getCurrentUserName() ?? 'Usuario';

    return Scaffold(
      backgroundColor: AppConstants.primaryDarkBlue,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryDarkBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.account_balance, color: AppConstants.neonBlue, size: 24),
            SizedBox(width: 10),
            Text(
              'ECOBANK',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white70),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con bienvenida
          _buildHeaderSection(userName),

          // Contenido principal
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF2C5364),
                    Color(0xFF203A43),
                    Color(0xFF0F2027),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de sección
                    _buildSectionTitle(),

                    SizedBox(height: 25),

                    // Grid de calculadoras
                    _buildCalculatorsGrid(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(String userName) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryDarkBlue,
            AppConstants.accentBlue,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo personalizado
          Text(
            '¡Bienvenido de vuelta!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
              color: Colors.white70,
            ),
          ),

          SizedBox(height: 5),

          // Nombre del usuario
          Text(
            userName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 15),

          // Mensaje de bienvenida
          Text(
            'Herramientas profesionales para tus cálculos financieros',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculadoras Financieras',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Selecciona la calculadora que necesitas',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorsGrid(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95,
        children: [
          // Fila 1
          CalculatorButton(
            title: 'Interés Simple',
            icon: Icons.calculate,
            onPressed: () => Navigator.pushNamed(context, '/simple-interest'),
          ),
          CalculatorButton(
            title: 'Interés Compuesto',
            icon: Icons.auto_graph,
            onPressed: () => Navigator.pushNamed(context, '/compound-interest'),
          ),
          // Fila 2
          CalculatorButton(
            title: 'Tasa de Interés',
            icon: Icons.trending_up,
            onPressed: () => Navigator.pushNamed(context, '/interest-rate'),
          ),
          CalculatorButton(
            title: 'Anualidades',
            icon: Icons.pie_chart,
            onPressed: () => Navigator.pushNamed(context, '/annuities'),
          ),
          // Fila 3
          CalculatorButton(
            title: 'Gradientes',
            icon: Icons.waterfall_chart,
            onPressed: () => Navigator.pushNamed(context, '/gradients'),
          ),
          CalculatorButton(
            title: 'Amortización',
            icon: Icons.account_balance,
            onPressed: () => Navigator.pushNamed(context, '/amortization'),
          ),
          // Fila 4 - NUEVOS BOTONES
          CalculatorButton(
            title: 'Capitalización',
            icon: Icons.attach_money,
            onPressed: () => Navigator.pushNamed(context, '/capitalization'),
          ),
          CalculatorButton(
            title: 'TIR',
            icon: Icons.stacked_line_chart,
            onPressed: () => Navigator.pushNamed(context, '/tir'),
          ),
        ],
      ),
    );
  }
}
