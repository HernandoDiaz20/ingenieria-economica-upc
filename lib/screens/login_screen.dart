import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      final cedula = _cedulaController.text;
      final password = _passwordController.text;

      if (AuthService.login(cedula, password)) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cédula o contraseña incorrectos'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _goBackToWelcome() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryDarkBlue,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Botón de regreso en la esquina superior izquierda
              _buildBackButton(),

              SizedBox(height: 20),

              // Header con logo
              _buildHeaderSection(),

              SizedBox(height: 40),

              // Formulario de login
              _buildLoginForm(),

              SizedBox(height: 20),

              // Opciones adicionales
              _buildAdditionalOptions(),

              SizedBox(height: 30),

              // Botón de login
              _buildLoginButton(),

              SizedBox(height: 25),

              // Link de registro
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppConstants.cardBlue.withOpacity(0.3),
        ),
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppConstants.neonBlue,
            size: 24,
          ),
          onPressed: _goBackToWelcome,
          splashRadius: 20,
          tooltip: 'Volver al inicio',
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Logo animado
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppConstants.cardBlue,
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
                AppConstants.accentBlue,
                AppConstants.primaryDarkBlue,
              ],
            ),
          ),
          child: Icon(
            Icons.account_balance_wallet,
            size: 45,
            color: AppConstants.neonBlue,
          ),
        ),

        SizedBox(height: 25),

        Text(
          'BIENVENIDO',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 2.0,
          ),
        ),

        SizedBox(height: 8),

        Text(
          'Ingresa a tu cuenta ECOBANK',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppConstants.cardBlue.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.neonBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Campo Cédula
            TextFormField(
              controller: _cedulaController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de Cédula',
                labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                prefixIcon:
                    Icon(Icons.badge_outlined, color: AppConstants.neonBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppConstants.neonBlue, width: 2),
                ),
                filled: true,
                fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.4),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su cédula';
                }
                if (value.length < 8) {
                  return 'La cédula debe tener 8 dígitos mínimo';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // Campo Contraseña
            TextFormField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                prefixIcon:
                    Icon(Icons.lock_outline, color: AppConstants.neonBlue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppConstants.neonBlue.withOpacity(0.7),
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppConstants.neonBlue, width: 2),
                ),
                filled: true,
                fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.4),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener 6 caracteres mínimo';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Recordarme
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppConstants.neonBlue,
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(AppConstants.neonBlue),
            ),
            Text(
              'Recordarme',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),

        // Olvidé contraseña
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forgot-password');
          },
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              color: AppConstants.neonBlue,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.neonBlue,
            AppConstants.deepBlue,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppConstants.deepBlue.withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'INICIAR SESIÓN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes una cuenta? ',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/register'),
          child: Text(
            'Regístrate aquí',
            style: TextStyle(
              color: AppConstants.neonBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
