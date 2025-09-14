import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _register() {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final cedula = _cedulaController.text;
      final password = _passwordController.text;

      if (AuthService.register(cedula, password, nombre)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registro exitoso. Ahora puedes iniciar sesión'),
          backgroundColor: AppConstants.neonBlue,
        ));
        // Navegar directamente a welcome screen usando named route
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Esta cédula ya está registrada'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _goBackToWelcome() {
    // Navegar directamente a welcome screen usando named route
    Navigator.pushReplacementNamed(context, '/');
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

              SizedBox(height: 30),

              // Formulario de registro
              _buildRegisterForm(),

              SizedBox(height: 30),

              // Botón de registro
              _buildRegisterButton(),

              SizedBox(height: 20),

              // Link para volver al login
              _buildLoginLink(),
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
        // Logo
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppConstants.cardBlue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.person_add_alt_1,
            size: 35,
            color: AppConstants.neonBlue,
          ),
        ),

        SizedBox(height: 20),

        Text(
          'CREAR CUENTA',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),

        SizedBox(height: 8),

        Text(
          'Completa tus datos para comenzar',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.cardBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppConstants.neonBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Campo Nombre Completo
            TextFormField(
              controller: _nombreController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.person, color: AppConstants.neonBlue),
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
                filled: true,
                fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.5),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su nombre completo';
                }
                if (value.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Campo Cédula
            TextFormField(
              controller: _cedulaController,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Cédula',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.badge, color: AppConstants.neonBlue),
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
                filled: true,
                fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.5),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su cédula';
                }
                if (value.length < 8) {
                  return 'La cédula debe tener al menos 8 dígitos';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Campo Contraseña
            TextFormField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white),
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.lock, color: AppConstants.neonBlue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppConstants.neonBlue.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
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
                filled: true,
                fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.5),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),

            SizedBox(height: 16),

            // Campo Confirmar Contraseña
            TextFormField(
              controller: _confirmPasswordController,
              style: TextStyle(color: Colors.white),
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon:
                    Icon(Icons.lock_outline, color: AppConstants.neonBlue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppConstants.neonBlue.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
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
                filled: true,
                fillColor: AppConstants.secondaryDarkBlue.withOpacity(0.5),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.neonBlue,
            AppConstants.deepBlue,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppConstants.deepBlue.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'CREAR CUENTA',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta? ',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navegar directamente a login screen usando named route
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            'Inicia sesión aquí',
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
