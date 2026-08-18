import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/state/auth_state.dart';
import '../../../../core/data/auth_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';
import '../../../../shared/widgets/inputs/search_field.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({
    super.key,
    this.onLogin,
    this.onEmailConfirmationRequired,
  });

  final VoidCallback? onLogin;
  final void Function(String email)? onEmailConfirmationRequired;

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();

  final _registerNameCtrl = TextEditingController();
  final _registerEmailCtrl = TextEditingController();
  final _registerPasswordCtrl = TextEditingController();

  bool _obscureLoginPassword = true;
  bool _obscureRegisterPassword = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();

    _registerNameCtrl.dispose();
    _registerEmailCtrl.dispose();
    _registerPasswordCtrl.dispose();

    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthState>();

    try {
      await authState.login(
        email: _loginEmailCtrl.text,
        password: _loginPasswordCtrl.text,
      );

      if (!mounted) {
        return;
      }

      widget.onLogin?.call();
    } on TravelBuddyAuthException catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showError(
        'Something went wrong while signing in. Please try again.',
      );
    }
  }

  Future<void> _submitRegister() async {
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthState>();

    try {
      final result = await authState.register(
        name: _registerNameCtrl.text,
        email: _registerEmailCtrl.text,
        password: _registerPasswordCtrl.text,
      );

      if (!mounted) {
        return;
      }

      if (result.requiresEmailConfirmation) {
        widget.onEmailConfirmationRequired?.call(
          result.user?.email ?? _registerEmailCtrl.text.trim(),
        );
        return;
      }

      widget.onLogin?.call();
    } on TravelBuddyAuthException catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showError(
        'Something went wrong while creating your account. Please try again.',
      );
    }
  }

  void _openForgotPassword() {
    context.go('/auth/forgot-password');
  }

  void _showGoogleMessage() {
    _showError(
      'Google Sign-In is not enabled yet.',
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthState>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // -----------------------------------------------------------------
            // Header
            // -----------------------------------------------------------------

            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/travelbuddy_horizontal.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.onPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Sign in to continue exploring India',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.75),
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusInputButton,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusInputButton,
                        ),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.primary,
                      unselectedLabelColor:
                          AppColors.onPrimary.withOpacity(0.7),
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Register'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // Forms
            // -----------------------------------------------------------------

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ===========================================================
                  // LOGIN
                  // ===========================================================

                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Email',
                            controller: _loginEmailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(AppIcons.person),
                            enabled: !isLoading,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Password',
                            controller: _loginPasswordCtrl,
                            obscureText: _obscureLoginPassword,
                            prefixIcon: const Icon(AppIcons.privacy),
                            enabled: !isLoading,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureLoginPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscureLoginPassword =
                                            !_obscureLoginPassword;
                                      });
                                    },
                              tooltip: _obscureLoginPassword
                                  ? 'Show password'
                                  : 'Hide password',
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: isLoading ? null : _openForgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          PrimaryButton(
                            label: 'Login',
                            onPressed: isLoading ? null : _submitLogin,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.outlineVariant,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                child: Text(
                                  'or',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.outlineVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          GhostButton(
                            label: 'Continue with Google',
                            icon: Icons.g_mobiledata,
                            onPressed: isLoading ? null : _showGoogleMessage,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ===========================================================
                  // REGISTER
                  // ===========================================================

                  SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Full Name',
                            controller: _registerNameCtrl,
                            prefixIcon: const Icon(AppIcons.person),
                            enabled: !isLoading,
                            validator: _validateName,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Email',
                            controller: _registerEmailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(AppIcons.person),
                            enabled: !isLoading,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          AppTextField(
                            label: 'Password',
                            controller: _registerPasswordCtrl,
                            obscureText: _obscureRegisterPassword,
                            prefixIcon: const Icon(AppIcons.privacy),
                            enabled: !isLoading,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureRegisterPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscureRegisterPassword =
                                            !_obscureRegisterPassword;
                                      });
                                    },
                              tooltip: _obscureRegisterPassword
                                  ? 'Show password'
                                  : 'Hide password',
                            ),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          CtaButton(
                            label: 'Create Account',
                            onPressed: isLoading ? null : _submitRegister,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          GhostButton(
                            label: 'Continue with Google',
                            icon: Icons.g_mobiledata,
                            onPressed: isLoading ? null : _showGoogleMessage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Please enter your full name.';
    }

    if (name.length < 2) {
      return 'Name must contain at least 2 characters.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email.';
    }

    final isValid = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);

    if (!isValid) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    if (password.length < 8) {
      return 'Password must contain at least 8 characters.';
    }

    return null;
  }
}
