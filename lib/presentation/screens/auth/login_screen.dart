import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/utils/validators.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AuthCubit(preferencesService: sl<PreferencesService>()),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go('/');
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.welcomeBack,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.signInToContinue,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        _buildGlassInput(
                          context: context,
                          colorScheme: colorScheme,
                          controller: _emailController,
                          label: l10n.email,
                          icon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildGlassInput(
                          context: context,
                          colorScheme: colorScheme,
                          controller: _passwordController,
                          label: l10n.password,
                          icon: Icons.lock_outline,
                          obscure: _obscurePassword,
                          toggleObscure: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          validator: (value) => Validators.validateMinLength(
                            value,
                            6,
                            fieldName: 'Password',
                          ),
                          onSubmitted: (_) => _signIn(context),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _showForgotPassword(context),
                            child: Text(
                              l10n.forgotPassword,
                              style: TextStyle(color: colorScheme.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPrimaryButton(
                          colorScheme: colorScheme,
                          isLoading: state is AuthLoading,
                          label: l10n.signIn,
                          onTap: () => _signIn(context),
                        ),
                        const SizedBox(height: 24),
                        _buildDividerWithOr(colorScheme),
                        const SizedBox(height: 24),
                        _buildGoogleButton(
                          context: context,
                          colorScheme: colorScheme,
                          isLoading: state is AuthLoading,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${l10n.noAccount} ",
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push('/signup'),
                              child: Text(
                                l10n.signUp,
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => context.go('/'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.5),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            l10n.continueAsGuest,
                            style: TextStyle(color: colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassInput({
    required BuildContext context,
    required ColorScheme colorScheme,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscure = false,
    VoidCallback? toggleObscure,
    void Function(String)? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: colorScheme.primary),
          suffixIcon: toggleObscure != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility : Icons.visibility_off,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: toggleObscure,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          filled: false,
        ),
        obscureText: obscure,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: onSubmitted != null
            ? TextInputAction.done
            : TextInputAction.next,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }

  Widget _buildPrimaryButton({
    required ColorScheme colorScheme,
    required bool isLoading,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  )
                : Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithOr(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: Divider(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
      ],
    );
  }

  Widget _buildGoogleButton({
    required BuildContext context,
    required ColorScheme colorScheme,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading
              ? null
              : () => context.read<AuthCubit>().signInWithGoogle(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.g_mobiledata,
                  color: colorScheme.onSurface,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _showForgotPassword(BuildContext context) {
    final emailController = TextEditingController(text: _emailController.text);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.resetPassword),
        content: TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: l10n.email,
            hintText: l10n.enterEmailAddress,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              context.read<AuthCubit>().resetPassword(
                emailController.text.trim(),
              );
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.passwordResetSent)));
            },
            child: Text(l10n.send),
          ),
        ],
      ),
    );
  }
}
