import 'package:equatable/equatable.dart';

import '../../domain/entities/home_sections.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final HomeSections sections;
  const HomeSuccess({required this.sections});
  @override
  List<Object?> get props => [sections];
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
  @override
  List<Object?> get props => [message];
}