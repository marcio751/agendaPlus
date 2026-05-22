class AuthStorage {
  static String? registeredName;
  static String? registeredEmail;
  static String? registeredPassword;

  static bool hasAccount() {
    return registeredEmail != null && registeredPassword != null;
  }

  static bool register(String name, String email, String password) {
    if (hasAccount()) return false;
    registeredName = name.trim();
    registeredEmail = email.trim().toLowerCase();
    registeredPassword = password;
    return true;
  }

  static bool verify(String usernameOrEmail, String password) {
    if (!hasAccount()) return false;
    final normalized = usernameOrEmail.trim().toLowerCase();
    return password == registeredPassword &&
        (normalized == registeredEmail || normalized == registeredName?.toLowerCase());
  }
}
