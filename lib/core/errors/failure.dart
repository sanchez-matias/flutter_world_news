import 'package:equatable/equatable.dart';
import 'package:flutter_world_news/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final int statusCode;
  final String message;

  const Failure({required this.statusCode, required this.message});

  String get errorMessage => '$statusCode - Error: $message';

  @override
  List<Object?> get props => [statusCode, message];
}

class ApiFailure extends Failure {
  const ApiFailure({
    required super.statusCode,
    required super.message,
  });

  ApiFailure.fromException(ApiException exception)
      : this(
          statusCode: exception.statusCode,
          message: exception.messagge,
        );
}
