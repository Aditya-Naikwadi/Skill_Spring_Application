import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../utils/validators.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _institutionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _institutionController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
        institution: _institutionController.text.trim(),
        phoneNumber: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        role: UserRole.student,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Registration failed'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF1565C0),
              Color(0xFF0D47A1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Join SkillSpring',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start your coding journey today',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Full Name
                          CustomTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                            prefixIcon: const Icon(Icons.person_outline),
                            validator: Validators.validateName,
                          ),
                          const SizedBox(height: 16),

                          // Email
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: 16),

                          // Phone (Optional)
                          CustomTextField(
                            controller: _phoneController,
                            label: 'Phone Number (Optional)',
                            hint: 'Enter your phone number',
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone_outlined),
                            validator: Validators.validatePhone,
                          ),
                          const SizedBox(height: 16),

                          // Institution
                          CustomTextField(
                            controller: _institutionController,
                            label: 'College/University',
                            hint: 'Enter your institution name',
                            prefixIcon: const Icon(Icons.school_outlined),
                            validator: (value) =>
                                Validators.validateRequired(value, 'Institution'),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Create a strong password',
                            obscureText: true,
                            prefixIcon: const Icon(Icons.lock_outline),
                            validator: Validators.validatePassword,
                            onChanged: (value) {
                              setState(() {}); // Rebuild for password strength
                            },
                          ),
                          const SizedBox(height: 8),

                          // Password Strength Indicator
                          if (_passwordController.text.isNotEmpty)
                            _buildPasswordStrength(),
                          const SizedBox(height: 16),

                          // Confirm Password
                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password',
                            hint: 'Re-enter your password',
                            obscureText: true,
                            prefixIcon: const Icon(Icons.lock_outline),
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Terms and Conditions
                          Row(
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  'I agree to the Terms and Conditions',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Register Button
                          CustomButton(
                            text: 'Create Account',
                            onPressed: _handleRegister,
                            isLoading: authProvider.isLoading,
                            height: 56,
                          ),
                          const SizedBox(height: 16),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrength() {
    final strength = Validators.getPasswordStrength(_passwordController.text);
    final label = Validators.getPasswordStrengthLabel(strength);
    final colors = [
      AppTheme.errorColor,
      Colors.orange,
      Colors.yellow[700]!,
      Colors.lightGreen,
      AppTheme.successColor,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 4 ? 4 : 0),
                decoration: BoxDecoration(
                  color: index < strength ? colors[strength - 1] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Password strength: $label',
          style: TextStyle(
            fontSize: 12,
            color: colors[strength > 0 ? strength - 1 : 0],
          ),
        ),
      ],
    );
  }
}
