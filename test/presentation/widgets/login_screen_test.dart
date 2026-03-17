import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/presentation/cubits/auth/auth_cubit.dart';
import 'package:btlmobile/presentation/cubits/auth/auth_state.dart';
import 'package:btlmobile/core/theme/app_colors.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
  });

  Widget createSubject() {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: AppColors.navyDark),
      home: BlocProvider<AuthCubit>.value(
        value: mockAuthCubit,
        child: Scaffold(
          backgroundColor: AppColors.navyDark,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    key: const Key('email_field'),
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('password_field'),
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    key: const Key('sign_in_button'),
                    onPressed: () {},
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    key: const Key('google_sign_in_button'),
                    onPressed: () => mockAuthCubit.signInWithGoogle(),
                    child: const Text('Continue with Google'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('Login Screen Widget Tests', () {
    testWidgets('renders login form elements', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createSubject());

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('sign_in_button')), findsOneWidget);
    });

    testWidgets('renders Google sign-in button', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createSubject());

      expect(find.text('Continue with Google'), findsOneWidget);
    });

    testWidgets('Google button taps calls signInWithGoogle', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(AuthInitial());
      when(() => mockAuthCubit.signInWithGoogle()).thenAnswer((_) async {});

      await tester.pumpWidget(createSubject());
      await tester.tap(find.byKey(const Key('google_sign_in_button')));
      await tester.pump();

      verify(() => mockAuthCubit.signInWithGoogle()).called(1);
    });

    testWidgets('shows loading indicator when AuthLoading', (tester) async {
      when(() => mockAuthCubit.state).thenReturn(AuthLoading());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: Scaffold(
              body: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const Text('Not Loading');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message on AuthError', (tester) async {
      when(
        () => mockAuthCubit.state,
      ).thenReturn(const AuthError('Invalid credentials'));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: Scaffold(
              body: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthError) {
                    return Text(state.message);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
