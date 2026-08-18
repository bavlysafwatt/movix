import 'package:equatable/equatable.dart';
import 'package:movix/features/splash/domain/entities/splash_destination.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashLoading extends SplashState {
  const SplashLoading();
}

final class SplashReady extends SplashState {
  const SplashReady(this.destination);

  final SplashDestination destination;

  @override
  List<Object?> get props => [destination];
}

final class SplashFailure extends SplashState {
  const SplashFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
