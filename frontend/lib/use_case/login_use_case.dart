class LoginUseCase {
  static bool login(String user, String password) {
    return (user == 'admin' && password == 'admin') ||
        (user == 'driver' && password == 'driver');
  }
}