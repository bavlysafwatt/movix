import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.isCompleting = false,
    this.errorMessage,
  });

  final int currentPage;
  final bool isCompleting;
  final String? errorMessage;

  OnboardingState copyWith({
    int? currentPage,
    bool? isCompleting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleting: isCompleting ?? this.isCompleting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [currentPage, isCompleting, errorMessage];
}
