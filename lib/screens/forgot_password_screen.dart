import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'verify_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  bool _isLoading = false;
  String? _lastGeneratedCode;

  void _requestRecoveryCode() {
    if (_formKey.currentState!.validate()) {
      final cedula = _cedulaController.text;

      if (!AuthService.userExists(cedula)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No existe una cuenta con esta cédula'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simular delay de red
      Future.delayed(Duration(seconds: 2), () {
        try {
          final recoveryCode = AuthService.generateRecoveryCode(cedula);

          setState(() {
            _isLoading = false;
            _lastGeneratedCode = recoveryCode;
          });

          // Navegar a la pantalla de verificación de código
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyCodeScreen(
                cedula: cedula,
                recoveryCode: recoveryCode,
              ),
            ),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al generar código de recuperación'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _showCodeAgain() {
    if (_lastGeneratedCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Primero debes generar un código'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.cardBlue,
        title: Text(
          'Código de Verificación',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tu código de verificación es:',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppConstants.neonBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppConstants.neonBlue),
              ),
              child: Text(
                _lastGeneratedCode!,
                style: TextStyle(
                  color: AppConstants.neonBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Este código expira en 15 minutos',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('CERRAR', style: TextStyle(color: AppConstants.neonBlue)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navegar directamente a VerifyCodeScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyCodeScreen(
                    cedula: _cedulaController.text,
                    recoveryCode: _lastGeneratedCode!,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.neonBlue,
            ),
            child: Text('CONTINUAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _goBackToLogin() {
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
              // Botón de regreso
              _buildBackButton(),

              SizedBox(height: 40),

              // Header
              _buildHeaderSection(),

              SizedBox(height: 40),

              // Formulario
              _buildRecoveryForm(),

              SizedBox(height: 20),

              // Botón para ver código nuevamente (solo si hay código generado)
              if (_lastGeneratedCode != null) _buildShowCodeButton(),

              SizedBox(height: 10),

              // Botón de enviar
              _buildSendButton(),
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
          onPressed: _goBackToLogin,
          splashRadius: 20,
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppConstants.cardBlue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(4, 4),
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
            Icons.lock_reset,
            size: 35,
            color: AppConstants.neonBlue,
          ),
        ),
        SizedBox(height: 25),
        Text(
          'RECUPERAR CONTRASEÑA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Ingresa tu cédula para recibir un código de verificación',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildRecoveryForm() {
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
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.neonBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppConstants.neonBlue.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppConstants.neonBlue, size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Se enviará un código de verificación a tu correo electrónico registrado',
                      style: TextStyle(
                        color: Colors.white70,
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
    );
  }

  Widget _buildShowCodeButton() {
    return OutlinedButton.icon(
      onPressed: _showCodeAgain,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.orange),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      icon: Icon(Icons.visibility, color: Colors.orange, size: 18),
      label: Text(
        'VER CÓDIGO NUEVAMENTE',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSendButton() {
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
        onPressed: _isLoading ? null : _requestRecoveryCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ENVIAR CÓDIGO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.send, size: 20, color: Colors.white),
                ],
              ),
      ),
    );
  }
}
