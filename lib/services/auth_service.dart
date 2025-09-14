class AuthService {
  // Simulación de base de datos de usuarios
  static final Map<String, Map<String, dynamic>> _users = {};
  static String? _currentUserCedula; // Guardar cédula del usuario logeado

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
      _currentUserCedula = cedula; // Guardar cédula del usuario logeado
      return true;
    }
    return false;
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
