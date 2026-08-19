import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsError extends SettingsState {
  const SettingsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded({required this.name, required this.email, required this.region});
  final String? name;
  final String? email;
  final String region;
  @override
  List<Object?> get props => [name, email, region];
}

class SettingsLoggingOut extends SettingsLoaded {
  const SettingsLoggingOut({required super.name, required super.email, required super.region});
}

class SettingsActionFailure extends SettingsLoaded {
  const SettingsActionFailure({
    required super.name,
    required super.email,
    required super.region,
    required this.message,
  });
  final String message;
  @override
  List<Object?> get props => [...super.props, message];
}

class SettingsLoggedOut extends SettingsState {}