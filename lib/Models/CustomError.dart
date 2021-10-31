class CustomError implements Exception {
  final String message;
  final String? code;
  const CustomError(this.message, {this.code});
}
