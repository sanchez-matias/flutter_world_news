import 'package:equatable/equatable.dart';

class ApiException extends Equatable implements Exception {
  final String messagge;
  final int statusCode;

  const ApiException({required this.messagge, required this.statusCode});

  @override
  List<Object?> get props => [messagge, statusCode];
}
