import 'package:equatable/equatable.dart';

enum AuthAction { idle, loading, authenticated, emailConfirmationRequired, resetEmailSent, failure }

class AuthState extends Equatable {
  const AuthState({this.action = AuthAction.idle, this.message});

  final AuthAction action;
  final String? message;

  @override
  List<Object?> get props => [action, message];
}
