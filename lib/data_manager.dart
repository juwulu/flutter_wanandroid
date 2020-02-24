class LoginStateManager {
  static bool _isLogin = false;

  static bool get isLogin => _isLogin;

  static set isLogin(bool value) {
    _isLogin = value;
  }
}
