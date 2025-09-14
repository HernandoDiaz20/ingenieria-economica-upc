import 'package:flutter/material.dart';
//import '../utils/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027), // Azul oscuro profundo
              Color(0xFF203A43), // Azul medio
              Color(0xFF2C5364), // Azul acero
            ],
            stops: [0.1, 0.5, 0.9],
          ),
        ),
        child: Stack(
          children: [
            // Fondos decorativos sutiles
            _buildBackgroundElements(size),

            // Contenido principal
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo y título
                  _buildHeaderSection(),

                  SizedBox(height: size.height * 0.06),

                  // Descripción
                  _buildDescriptionSection(),

                  SizedBox(height: size.height * 0.12),

                  // Botones de acción
                  _buildActionButtons(context),

                  SizedBox(height: 20),

                  // Texto de seguridad
                  _buildSecurityText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements(Size size) {
    return Stack(
      children: [
        // Círculos decorativos sutiles
        Positioned(
          top: size.height * 0.1,
          right: -size.width * 0.2,
          child: Container(
            width: size.width * 0.5,
            height: size.width * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFF00B4DB).withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: [0.1, 0.8],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: size.height * 0.2,
          left: -size.width * 0.1,
          child: Container(
            width: size.width * 0.3,
            height: size.width * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFA8FF78).withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: [0.1, 0.8],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Logo minimalista
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1E3A5F),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(4, 4),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                blurRadius: 15,
                offset: Offset(-4, -4),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2C5364),
                Color(0xFF0F2027),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.account_balance,
              size: 50,
              color: Color(0xFF00B4DB),
            ),
          ),
        ),

        SizedBox(height: 20),

        // Título principal - ECOBANK
        Text(
          'ECOBANK',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 2.0,
            fontFamily: 'Roboto',
          ),
        ),

        SizedBox(height: 4),

        // Subtítulo - UPC FINANCE
        Text(
          'UPC FINANCE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Color(0xFF00B4DB),
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      children: [
        // INGENIERÍA ECONÓMICA
        Text(
          'INGENIERÍA ECONÓMICA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),

        SizedBox(height: 16),

        // Descripción
        Text(
          'Herramientas profesionales para\ncálculos financieros avanzados',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
            height: 1.5,
          ),
        ),

        SizedBox(height: 24),

        // Línea divisoria elegante
        Container(
          width: 100,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFF00B4DB).withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Botón de Iniciar Sesión
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00B4DB),
                Color(0xFF0083B0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF0083B0).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'INICIAR SESIÓN',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),

        SizedBox(height: 16),

        // Botón de Registro
        Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFF00B4DB),
              width: 1.5,
            ),
          ),
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide.none,
            ),
            child: Text(
              'CREAR CUENTA',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00B4DB),
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityText() {
    return Text(
      '🔒 Datos protegidos con encriptación bancaria',
      style: TextStyle(
        fontSize: 11,
        color: Colors.white54,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
