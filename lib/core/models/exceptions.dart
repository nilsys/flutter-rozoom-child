class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}

class TokenException implements Exception {
  final String message;

  TokenException({this.message});
  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of TokenException
  }
}
