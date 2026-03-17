import 'package:equatable/equatable.dart';

import '../../../domain/entities/gym.dart';

abstract class GymFormState extends Equatable {
  const GymFormState();

  @override
  List<Object?> get props => [];
}

class GymFormInitial extends GymFormState {}

class GymFormEditing extends GymFormState {
  final Gym? gym;
  final bool isEditMode;

  const GymFormEditing({this.gym, this.isEditMode = false});

  @override
  List<Object?> get props => [gym, isEditMode];
}

class GymFormSubmitting extends GymFormState {}

class GymFormSuccess extends GymFormState {
  final String message;
  final bool isUpdate;

  const GymFormSuccess({required this.message, this.isUpdate = false});

  @override
  List<Object?> get props => [message, isUpdate];
}

class GymFormError extends GymFormState {
  final String message;

  const GymFormError(this.message);

  @override
  List<Object?> get props => [message];
}
