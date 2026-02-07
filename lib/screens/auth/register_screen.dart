import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/level_selector.dart';
import '../../widgets/common/hover_scale_button.dart';
import '../../utils/validators.dart';
import '../../models/user_model.dart'; // Ensure this model exists

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Additional fields
  ExperienceLevel _selectedLevel = ExperienceLevel.beginner;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      final success = await authProvider.registerUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
        institution: 'Self-Taught', 
        role: UserRole.student, 
        // TODO: Pass _selectedLevel to backend if needed
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Registration failed'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDeepWide = constraints.maxWidth > 900;
           if (isDeepWide) {
            return Row(
              children: [
                 // Left Side - Branding / Art
                Expanded(
                  flex: 5,
                  child: Container(
                    color: const Color(0xFF161B22),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                         // Background Blobs/Gradient
                        Positioned(
                          bottom: -100,
                          right: -100,
                           child: Container(
                            width: 600,
                            height: 600,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF03A9F4).withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        
                        // Centered Content
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ZoomIn(
                              duration: const Duration(milliseconds: 800),
                              child: GlassmorphicContainer(
                                width: 220,
                                height: 220,
                                borderRadius: 40,
                                blur: 20,
                                alignment: Alignment.center,
                                border: 2,
                                linearGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                ),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.5),
                                    Colors.white.withValues(alpha: 0.1),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_add_alt_1_rounded,
                                  size: 100,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            FadeInUp(
                              delay: const Duration(milliseconds: 200),
                              child: Text(
                                'Join the Community',
                                style: GoogleFonts.poppins(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                             FadeInUp(
                              delay: const Duration(milliseconds: 400),
                              child: Text(
                                'Start building your future today.',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                 // Right Side - Form
                Expanded(
                  flex: 4,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                        child: _buildRegisterForm(context, true),
                      ),
                    ),
                  ),
                ),
              ],
            );
           }

          // Mobile Layout
          return Center(
             child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: _buildRegisterForm(context, false),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isWide) ...[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 24),
        ],
        
        FadeInDown(
          child: Text(
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        FadeInDown(
           delay: const Duration(milliseconds: 100),
           child: Text(
            'Start your journey to becoming a master developer.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),

        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name
              FadeInUp(
                 delay: const Duration(milliseconds: 100),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _buildLabel('Full Name'),
                     _buildTextField(
                        controller: _nameController,
                        hint: 'John Doe',
                        icon: Icons.person_outline,
                        validator: Validators.validateName,
                      ),
                   ],
                 ),
              ),
              const SizedBox(height: 20),

              // Email Address
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Email Address'),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'dev@example.com',
                      icon: Icons.alternate_email,
                      validator: Validators.validateEmail,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Password
              FadeInUp(
                 delay: const Duration(milliseconds: 300),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _buildLabel('Password'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.grey[500],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFF161B22),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 8),
                    
                    // Password Strength
                    if (_passwordController.text.isNotEmpty)
                      _buildPasswordStrength(),
                   ],
                 ),
              ),
              
              const SizedBox(height: 24),

              // Experience Level
              FadeInUp(
                 delay: const Duration(milliseconds: 400),
                 child: LevelSelector(
                  selectedLevel: _selectedLevel,
                  onLevelSelected: (level) {
                    setState(() {
                      _selectedLevel = level;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Create Account Button
              FadeInUp(
                 delay: const Duration(milliseconds: 500),
                child: SizedBox(
                   width: double.infinity,
                  height: 56,
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return HoverScaleButton(
                        onPressed: auth.isLoading ? null : _handleRegister,
                        color: const Color(0xFF2196F3),
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Create Account',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.person_add_alt_1, color: Colors.white, size: 20),
                                ],
                              ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Login Link
              FadeInUp(
                 delay: const Duration(milliseconds: 600),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.poppins(color: Colors.grey[500]),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                           onTap: () {
                             if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                             } else {
                               Navigator.pushReplacementNamed(context, '/login');
                             }
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2196F3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.grey[300],
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[500]),
        filled: true,
        fillColor: const Color(0xFF161B22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2196F3)),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordStrength() {
     // Leveraging logic similar to existing validator but styled for new dark theme
    final strength = Validators.getPasswordStrength(_passwordController.text);
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];
    final labels = ['Weak', 'Fair', 'Good', 'Strong', 'Excellent'];

    return Row(
      children: [
        ...List.generate(5, (index) {
           // simple size animation could go here, but keeping static for now
          return Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < strength ? colors[index] : Colors.grey[800],
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          strength > 0 ? labels[strength - 1] : '',
          style: GoogleFonts.poppins(
            color: strength > 0 ? colors[strength - 1] : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

