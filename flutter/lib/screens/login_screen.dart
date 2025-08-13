import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';
import '../core/validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Login failed'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.montserrat(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Email Field
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<LoginBloc>().add(LoginEmailChanged(value));
                            },
                            validator: Validators.validateEmail,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<LoginBloc>().add(LoginPasswordChanged(value));
                            },
                            validator: Validators.validatePassword,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password Criteria Helper
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          if (state.password.isEmpty) return const SizedBox.shrink();

                          final criteria = Validators.checkPasswordCriteria(state.password);
                          final criteriaList = [
                            {'text': 'At least 8 characters', 'key': 'length'},
                            {'text': 'One uppercase letter', 'key': 'uppercase'},
                            {'text': 'One lowercase letter', 'key': 'lowercase'},
                            {'text': 'One numeric digit', 'key': 'numeric'},
                            {'text': 'One special character', 'key': 'special'},
                          ];

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Password Requirements:',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...criteriaList.map((item) {
                                  final isValid = criteria[item['key']] ?? false;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
                                          size: 16,
                                          color: isValid ? Colors.green : Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          item['text']!,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            color: isValid ? Colors.green : Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // Submit Button
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton(
                              onPressed: state.status == LoginStatus.loading || !state.isFormValid
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginBloc>().add(const LoginSubmitted());
                                      }
                                    },
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: state.status == LoginStatus.loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                      'Sign In',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
