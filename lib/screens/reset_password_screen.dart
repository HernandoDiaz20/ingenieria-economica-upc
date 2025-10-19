import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String cedula;

  const ResetPasswordScreen({Key? key, required this.cedula}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(Duration(seconds: 1), () {
        final success = AuthService.resetPassword(
          widget.cedula,
          _newPasswordController.text,
        );

        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contraseña restablecida exitosamente'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al restablecer contraseña'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
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
              SizedBox(height: 60),
              _buildHeaderSection(),
              SizedBox(height: 40),
              _buildResetForm(),
              SizedBox(height: 30),
              _buildResetButton(),
            ],
          ),
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
          child: Icon(Icons.lock_open, size: 35, color: AppConstants.neonBlue),
        ),
        SizedBox(height: 25),
        Text('NUEVA CONTRASEÑA',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        SizedBox(height: 12),
        Text('Crea una nueva contraseña para tu cuenta',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w300)),
      ],
    );
  }

  Widget _buildResetForm() {
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
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                prefixIcon:
                    Icon(Icons.lock_outline, color: AppConstants.neonBlue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppConstants.neonBlue.withOpacity(0.7),
                  ),
                  onPressed: _toggleNewPasswordVisibility,
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
                  return 'Ingresa la nueva contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              style: TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                labelStyle: TextStyle(color: Colors.white70, fontSize: 14),
                prefixIcon:
                    Icon(Icons.lock_outline, color: AppConstants.neonBlue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppConstants.neonBlue.withOpacity(0.7),
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
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
                  return 'Confirma tu contraseña';
                }
                if (value != _newPasswordController.text) {
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

  Widget _buildResetButton() {
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
        onPressed: _isLoading ? null : _resetPassword,
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
                  Text('RESTABLECER CONTRASEÑA',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(width: 10),
                  Icon(Icons.check_circle, size: 20, color: Colors.white),
                ],
              ),
      ),
    );
  }
}
