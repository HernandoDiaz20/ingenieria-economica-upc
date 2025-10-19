import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'reset_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String cedula;
  final String recoveryCode;

  const VerifyCodeScreen({
    Key? key,
    required this.cedula,
    required this.recoveryCode,
  }) : super(key: key);

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _showCodeInDevelopment();
  }

  void _showCodeInDevelopment() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppConstants.cardBlue,
          title: Text(
            'Código de Verificación',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Código para restablecer su contraseña:',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 10),
              // Mostrar código con opción de copiar
              _buildCodeDisplay(),
              SizedBox(height: 10),
              Text(
                'En producción, este código se enviaría por email/SMS.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: AppConstants.neonBlue)),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCodeDisplay() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppConstants.neonBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstants.neonBlue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.recoveryCode,
            style: TextStyle(
              color: AppConstants.neonBlue,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          IconButton(
            icon: Icon(Icons.content_copy, color: AppConstants.neonBlue),
            onPressed: () => _copyToClipboard(widget.recoveryCode),
            tooltip: 'Copiar código',
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código copiado al portapapeles'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _verifyCode() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular verificación
      Future.delayed(Duration(seconds: 1), () {
        final isValid =
            AuthService.verifyRecoveryCode(widget.cedula, _codeController.text);

        setState(() {
          _isLoading = false;
        });

        if (isValid) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(cedula: widget.cedula),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Código inválido o expirado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _goBack() {
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
              _buildBackButton(),
              SizedBox(height: 40),
              _buildHeaderSection(),
              SizedBox(height: 40),
              _buildVerificationForm(),
              SizedBox(height: 20),
              _buildShowCodeButton(),
              SizedBox(height: 10),
              _buildVerifyButton(),
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
          icon: Icon(Icons.arrow_back_rounded, color: AppConstants.neonBlue),
          onPressed: _goBack,
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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppConstants.accentBlue, AppConstants.primaryDarkBlue],
            ),
          ),
          child:
              Icon(Icons.verified_user, size: 35, color: AppConstants.neonBlue),
        ),
        SizedBox(height: 25),
        Text('VERIFICAR CÓDIGO',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        SizedBox(height: 12),
        Text(
          'Ingresa el código de 6 dígitos enviado',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationForm() {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppConstants.cardBlue.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.neonBlue.withOpacity(0.2)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _codeController,
              style: TextStyle(color: Colors.white, fontSize: 16),
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'Código de Verificación',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.code, color: AppConstants.neonBlue),
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
                  return 'Ingresa el código';
                }
                if (value.length != 6) {
                  return 'El código debe tener 6 dígitos';
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.orange, size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'El código expira en 15 minutos',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
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
      onPressed: _showCodeInDevelopment,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppConstants.neonBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      icon: Icon(Icons.visibility, color: AppConstants.neonBlue, size: 18),
      label: Text(
        'MOSTRAR CÓDIGO',
        style: TextStyle(
          color: AppConstants.neonBlue,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppConstants.neonBlue, AppConstants.deepBlue],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: _isLoading
            ? CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('VERIFICAR',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(width: 10),
                  Icon(Icons.verified, size: 20, color: Colors.white),
                ],
              ),
      ),
    );
  }
}
