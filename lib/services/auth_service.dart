import 'dart:math';

class AuthService {
  // Simulación de base de datos de usuarios
  static final Map<String, Map<String, dynamic>> _users = {};
  static String? _currentUserCedula;

  // Simulación de códigos de recuperación (en un caso real, esto sería en una base de datos)
  static final Map<String, Map<String, dynamic>> _recoveryCodes = {};

  // Registrar usuario con nombre
  static bool register(String cedula, String password, String nombre) {
    if (_users.containsKey(cedula)) {
      return false; // Usuario ya existe
    }
    _users[cedula] = {
      'password': password,
      'nombre': nombre,
      'cedula': cedula,
    };
    return true;
  }

  // Login de usuario
  static bool login(String cedula, String password) {
    if (_users.containsKey(cedula) && _users[cedula]!['password'] == password) {
      _currentUserCedula = cedula;
      return true;
    }
    return false;
  }

  // Generar código de recuperación
  static String generateRecoveryCode(String cedula) {
    if (!_users.containsKey(cedula)) {
      throw Exception('Usuario no encontrado');
    }

    // Generar código de 6 dígitos
    final code = (100000 + Random().nextInt(900000)).toString();
    final expiryTime =
        DateTime.now().add(Duration(minutes: 15)); // 15 minutos de validez

    _recoveryCodes[cedula] = {
      'code': code,
      'expiry': expiryTime,
      'verified': false
    };

    return code;
  }

  // Verificar código de recuperación
  static bool verifyRecoveryCode(String cedula, String code) {
    if (!_recoveryCodes.containsKey(cedula)) {
      return false;
    }

    final recoveryData = _recoveryCodes[cedula]!;
    final now = DateTime.now();

    // Verificar si el código ha expirado
    if (now.isAfter(recoveryData['expiry'])) {
      _recoveryCodes.remove(cedula);
      return false;
    }

    if (recoveryData['code'] == code) {
      _recoveryCodes[cedula]!['verified'] = true;
      return true;
    }

    return false;
  }

  // Cambiar contraseña después de verificación
  static bool resetPassword(String cedula, String newPassword) {
    if (!_users.containsKey(cedula) ||
        !_recoveryCodes.containsKey(cedula) ||
        !_recoveryCodes[cedula]!['verified']) {
      return false;
    }

    _users[cedula]!['password'] = newPassword;
    _recoveryCodes.remove(cedula); // Limpiar código usado

    return true;
  }

  // Obtener datos del usuario actual
  static Map<String, dynamic>? getCurrentUserData() {
    if (_currentUserCedula != null && _users.containsKey(_currentUserCedula)) {
      return _users[_currentUserCedula];
    }
    return null;
  }

  // Obtener nombre del usuario actual
  static String? getCurrentUserName() {
    final userData = getCurrentUserData();
    return userData?['nombre'] as String?;
  }

  // Obtener cédula del usuario actual
  static String? getCurrentUserCedula() {
    return _currentUserCedula;
  }

  // Cerrar sesión
  static void logout() {
    _currentUserCedula = null;
  }

  // Verificar si hay usuario logeado
  static bool isLoggedIn() {
    return _currentUserCedula != null;
  }

  // Verificar si usuario existe
  static bool userExists(String cedula) {
    return _users.containsKey(cedula);
  }
}
