class AuthService {
  // Simulación de base de datos de usuarios
  static final Map<String, String> _users = {};

  // Registrar usuario
  static bool register(String cedula, String password) {
    if (_users.containsKey(cedula)) {
      return false; // Usuario ya existe
    }
    _users[cedula] = password;
    return true;
  }

  // Login de usuario
  static bool login(String cedula, String password) {
    return _users[cedula] == password;
  }

  // Verificar si usuario existe
  static bool userExists(String cedula) {
    return _users.containsKey(cedula);
  }
}
