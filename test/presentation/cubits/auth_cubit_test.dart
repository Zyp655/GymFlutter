import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/core/services/preferences_service.dart';
import 'package:btlmobile/presentation/cubits/auth/auth_cubit.dart';
import 'package:btlmobile/presentation/cubits/auth/auth_state.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockPreferencesService extends Mock implements PreferencesService {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockPreferencesService mockPrefsService;
  late AuthCubit cubit;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockPrefsService = MockPreferencesService();

    when(() => mockPrefsService.setUserId(any())).thenAnswer((_) async {});

    cubit = AuthCubit(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
      preferencesService: mockPrefsService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(cubit.state, isA<AuthInitial>());
    });

    group('checkAuthState', () {
      blocTest<AuthCubit, AuthState>(
        'emits Authenticated when user is logged in',
        build: () {
          final mockUser = MockUser();
          when(() => mockUser.uid).thenReturn('uid123');
          when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
          return cubit;
        },
        act: (cubit) => cubit.checkAuthState(),
        expect: () => [isA<Authenticated>()],
        verify: (_) {
          verify(() => mockPrefsService.setUserId('uid123')).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits Unauthenticated when no user',
        build: () {
          when(() => mockFirebaseAuth.currentUser).thenReturn(null);
          return cubit;
        },
        act: (cubit) => cubit.checkAuthState(),
        expect: () => [isA<Unauthenticated>()],
        verify: (_) {
          verify(() => mockPrefsService.setUserId(null)).called(1);
        },
      );
    });

    group('signInWithEmail', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, Authenticated] on success',
        build: () {
          final mockUser = MockUser();
          final mockCred = MockUserCredential();
          when(() => mockUser.uid).thenReturn('uid123');
          when(() => mockUser.email).thenReturn('test@test.com');
          when(() => mockCred.user).thenReturn(mockUser);
          when(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => mockCred);
          return cubit;
        },
        act: (cubit) => cubit.signInWithEmail(
          email: 'test@test.com',
          password: 'password123',
        ),
        expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] on failure',
        build: () {
          when(
            () => mockFirebaseAuth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Auth failed'));
          return cubit;
        },
        act: (cubit) =>
            cubit.signInWithEmail(email: 'test@test.com', password: 'wrong'),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );
    });

    group('signInWithGoogle', () {
      blocTest<AuthCubit, AuthState>(
        'emits Unauthenticated when user cancels Google sign-in',
        build: () {
          when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
          return cubit;
        },
        act: (cubit) => cubit.signInWithGoogle(),
        expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when Google sign-in throws',
        build: () {
          when(
            () => mockGoogleSignIn.signIn(),
          ).thenThrow(Exception('Network error'));
          return cubit;
        },
        act: (cubit) => cubit.signInWithGoogle(),
        expect: () => [isA<AuthLoading>(), isA<AuthError>()],
      );
    });

    group('signOut', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, Unauthenticated] on sign out',
        build: () {
          when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
          when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.signOut(),
        expect: () => [isA<AuthLoading>(), isA<Unauthenticated>()],
        verify: (_) {
          verify(() => mockPrefsService.setUserId(null)).called(1);
        },
      );
    });

    group('signUpWithEmail', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, Authenticated] on success',
        build: () {
          final mockUser = MockUser();
          final mockCred = MockUserCredential();
          when(() => mockUser.uid).thenReturn('new_uid');
          when(() => mockUser.email).thenReturn('new@test.com');
          when(() => mockCred.user).thenReturn(mockUser);
          when(
            () => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => mockCred);
          return cubit;
        },
        act: (cubit) => cubit.signUpWithEmail(
          email: 'new@test.com',
          password: 'password123',
        ),
        expect: () => [isA<AuthLoading>(), isA<Authenticated>()],
      );
    });
  });
}
