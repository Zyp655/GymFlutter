import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/app_logger.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/repositories/user_repository.dart';
import 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserRepository _userRepository;

  UserProfileCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(UserProfileInitial());

  Future<void> loadProfile(
    String uid, {
    String? email,
    String? displayName,
    String? photoUrl,
  }) async {
    emit(UserProfileLoading());
    try {
      var profile = await _userRepository.getProfile(uid);

      if (profile == null) {
        profile = UserProfile(
          uid: uid,
          email: email ?? '',
          displayName: displayName ?? '',
          photoUrl: photoUrl ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _userRepository.createProfile(profile);
        AppLogger.i('Created new profile for $uid');
      }

      emit(UserProfileLoaded(profile));
    } catch (e, stackTrace) {
      AppLogger.e('Error loading profile', e, stackTrace);
      emit(UserProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    final currentState = state;
    if (currentState is UserProfileLoaded) {
      try {
        final updated = currentState.profile.copyWith(
          displayName: displayName,
          photoUrl: photoUrl,
          updatedAt: DateTime.now(),
        );
        await _userRepository.updateProfile(updated);
        emit(UserProfileLoaded(updated));
      } catch (e) {
        emit(UserProfileError(e.toString()));
      }
    }
  }
}
