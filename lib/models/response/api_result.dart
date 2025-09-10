class ApiResult<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  ApiResult({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors
  });
}
