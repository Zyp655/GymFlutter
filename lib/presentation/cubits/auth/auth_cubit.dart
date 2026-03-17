import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/services/app_logger.dart';
import '../../../core/services/preferences_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final PreferencesService _preferencesService;
  final GoogleSignIn _googleSignIn;
  StreamSubscription<User?>? _authSubscription;

  AuthCubit({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    required PreferencesService preferencesService,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       _preferencesService = preferencesService,
       super(AuthInitial());

  void listenToAuthChanges() {
    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        _preferencesService.setUserId(user.uid);
        emit(Authenticated(user));
      } else {
        _preferencesService.setUserId(null);
        emit(Unauthenticated());
      }
    });
  }

  void checkAuthState() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      _preferencesService.setUserId(user.uid);
      emit(Authenticated(user));
    } else {
      _preferencesService.setUserId(null);
      emit(Unauthenticated());
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        AppLogger.i('User signed in: ${credential.user!.email}');
        _preferencesService.setUserId(credential.user!.uid);
        emit(Authenticated(credential.user!));
      } else {
        emit(const AuthError('Sign in failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      AppLogger.w('Sign in failed: ${e.code}');
      emit(AuthError(_getErrorMessage(e.code)));
    } catch (e, stackTrace) {
      AppLogger.e('Sign in error', e, stackTrace);
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(Unauthenticated());
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        AppLogger.i('Google sign in: ${userCredential.user!.email}');
        _preferencesService.setUserId(userCredential.user!.uid);
        emit(Authenticated(userCredential.user!));
      } else {
        emit(const AuthError('Google sign in failed.'));
      }
    } catch (e, stackTrace) {
      AppLogger.e('Google sign in error', e, stackTrace);
      emit(AuthError('Google sign in failed: ${e.toString()}'));
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        AppLogger.i('User signed up: ${credential.user!.email}');
        _preferencesService.setUserId(credential.user!.uid);
        emit(Authenticated(credential.user!));
      } else {
        emit(const AuthError('Sign up failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getErrorMessage(e.code)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _preferencesService.setUserId(null);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      emit(Unauthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_getErrorMessage(e.code)));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
