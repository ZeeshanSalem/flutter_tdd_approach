import 'dart:convert';

ErrorResponse? errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  ErrorResponse({
    String? error,
    String? errorDescription,
  }) {
    _error = error;
    _errorDescription = errorDescription;
  }

  ErrorResponse.fromJson(dynamic json) {
    _error = json['error'];
    _errorDescription = json['error_description'];
  }

  String? _error;
  String? _errorDescription;

  String? get error => _error;

  String? get errorDescription => _errorDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['error_description'] = _errorDescription;
    return map;
  }
}