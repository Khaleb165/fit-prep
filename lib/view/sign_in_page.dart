import 'package:fit_prep/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/auth_page_scaffold.dart';
import '../view_model/auth_provider.dart';
import 'home_screen.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final AuthProvider authProvider = context.read<AuthProvider>();
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      await authProvider.signIn(username: username, password: password);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in successful!')),
      );

      if (authProvider.isAuthenticated) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.errorMessage ?? 'Sign-in failed. Please try again.',
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  void _openSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in with your username to keep your prep moving.',
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: _requiredValidator('Username is required.'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  tooltip:
                      _isPasswordVisible ? 'Hide password' : 'Show password',
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              validator: _requiredValidator('Password is required.'),
              onFieldSubmitted: (_) => _handleSignIn(),
            ),
            const SizedBox(height: 28),
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return AuthSubmitButton(
                  label: 'Sign In',
                  isLoading: authProvider.isLoading,
                  onPressed: _handleSignIn,
                );
              },
            ),
            const SizedBox(height: 20),
            AuthSwitchPrompt(
              message: 'New to FitPrep?',
              actionLabel: 'Sign Up',
              onPressed: _openSignUp,
            ),
          ],
        ),
      ),
    );
  }
}

String? Function(String?) _requiredValidator(String message) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  };
}
