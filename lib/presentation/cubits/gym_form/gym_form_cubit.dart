import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/notification_service.dart';

import '../../../domain/entities/gym.dart';
import '../../../domain/usecases/gym_commands.dart';
import '../../../domain/usecases/gym_queries.dart';
import 'gym_form_state.dart';

class GymFormCubit extends Cubit<GymFormState> {
  final GetGymById _getGymById;
  final InsertGym _insertGym;
  final UpdateGym _updateGym;

  GymFormCubit({
    required GetGymById getGymById,
    required InsertGym insertGym,
    required UpdateGym updateGym,
  }) : _getGymById = getGymById,
       _insertGym = insertGym,
       _updateGym = updateGym,
       super(GymFormInitial());

  void initializeForCreate() {
    emit(const GymFormEditing(isEditMode: false));
  }

  Future<void> initializeForEdit(int gymId) async {
    try {
      final gym = await _getGymById(gymId);
      if (gym != null) {
        emit(GymFormEditing(gym: gym, isEditMode: true));
      } else {
        emit(const GymFormError('Gym not found'));
      }
    } catch (e) {
      emit(GymFormError(e.toString()));
    }
  }

  Future<void> submitGym({
    required String name,
    required String address,
    required String phoneNumber,
    required String email,
    required String description,
    required String imageUrl,
    required double latitude,
    required double longitude,
    required String openingHours,
    required List<String> facilities,
  }) async {
    final currentState = state;
    if (currentState is! GymFormEditing) return;

    emit(GymFormSubmitting());

    try {
      final now = DateTime.now();
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      final gym = Gym(
        id: currentState.gym?.id,
        name: name,
        address: address,
        phoneNumber: phoneNumber,
        email: email,
        description: description,
        imageUrl: imageUrl,
        rating: currentState.gym?.rating ?? 0.0,
        latitude: latitude,
        longitude: longitude,
        openingHours: openingHours,
        facilities: facilities,
        createdBy: currentState.gym?.createdBy ?? currentUid,
        createdAt: currentState.gym?.createdAt ?? now,
        updatedAt: now,
      );

      if (currentState.isEditMode) {
        await _updateGym(gym);
        emit(
          const GymFormSuccess(
            message: 'Gym updated successfully',
            isUpdate: true,
          ),
        );
      } else {
        await _insertGym(gym);
        await NotificationService.notifyNewGym(gymName: name);
        emit(
          const GymFormSuccess(
            message: 'Gym added successfully',
            isUpdate: false,
          ),
        );
      }
    } catch (e) {
      emit(GymFormError(e.toString()));
    }
  }
}
