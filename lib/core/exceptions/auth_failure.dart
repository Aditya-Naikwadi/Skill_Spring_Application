class AuthFailure implements Exception {
  final String message;
  final String code;

  AuthFailure(this.message, this.code);

  @override
  String toString() => message;
}
