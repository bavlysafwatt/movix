import 'package:equatable/equatable.dart';

import '../utils/app_strings.dart';

class GenericException extends Equatable implements Exception {
  final String message;

  const GenericException({required this.message});

  @override
  List<Object?> get props => [message];
}

class FetchDataException extends GenericException {
  const FetchDataException([String? message])
    : super(message: message ?? AppStrings.fetchDataException);
}

class BadRequestException extends GenericException {
  const BadRequestException({String? message})
    : super(message: message ?? AppStrings.badRequestException);
}

class UnauthorizedException extends GenericException {
  const UnauthorizedException({String? message})
    : super(message: message ?? AppStrings.unauthorizedException);
}

class NotFoundException extends GenericException {
  const NotFoundException({String? message})
    : super(message: message ?? AppStrings.notFoundException);
}

class ConflictException extends GenericException {
  const ConflictException({String? message})
    : super(message: message ?? AppStrings.conflictException);
}

class InternalServerErrorException extends GenericException {
  const InternalServerErrorException([String? message])
    : super(message: message ?? AppStrings.internalServerErrorException);
}

class NoInternetConnectionException extends GenericException {
  const NoInternetConnectionException([String? message])
    : super(message: message ?? AppStrings.noNetworkConnectionException);
}

class CacheException extends GenericException {
  const CacheException([String? message])
    : super(message: message ?? AppStrings.cacheException);
}

class TooManyRequestsException extends GenericException {
  const TooManyRequestsException([String? message])
      : super(message: message ?? AppStrings.tooManyRequestsException);
}
