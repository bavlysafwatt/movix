import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/core/usecase/usecase.dart';
import 'package:movix/features/auth/domain/repositories/auth_repository.dart';
import 'package:movix/features/auth/domain/usecases/sign_in_with_google.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithGoogle _signInWithGoogle;
  late final StreamSubscription _subscription;

  AuthCubit({
    required AuthRepository repository,
    required SignInWithGoogle signInWithGoogle,
  })  :_signInWithGoogle = signInWithGoogle,
        super(const AuthState()) {
    _subscription = repository.authStateChanges().listen((user) {
      if (user != null) emit(const AuthState(action: AuthAction.authenticated));
    });
  }

  Future<void> signInWithGoogle() => _perform(
    _signInWithGoogle(const NoParams()),
    success: AuthAction.authenticated,
  );

  Future<void> _perform(Future<dynamic> operation, {required AuthAction success}) async {
    emit(const AuthState(action: AuthAction.loading));
    final result = await operation;
    if (isClosed) return;
    result.fold(
      (error) => emit(AuthState(action: AuthAction.failure, message: error.message)),
      (_) => emit(AuthState(action: success)),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
