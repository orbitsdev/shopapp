class HttpExeption implements Exception {
  String message;

  HttpExeption(
    this.message,
  );

  @override
  String toString() {
    return message;
  }
}
