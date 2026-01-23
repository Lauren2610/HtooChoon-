import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              // WEBDESKTOP VIEW (Split Screen)
              return Row(
                children: [
                  const Expanded(flex: 5, child: AuthFormLeft()),
                  Expanded(flex: 5, child: RightSideVisual()),
                ],
              );
            } else {
              // MOBILE VIEW (Single Column)
              return const Center(
                child: AuthFormLeft(),
              );
            }
          },
        ),
      ),
    );
  }
}

class AuthFormLeft extends StatefulWidget {
  const AuthFormLeft({super.key});

  @override
  State<AuthFormLeft> createState() => _AuthFormLeftState();
}

class _AuthFormLeftState extends State<AuthFormLeft> {
  bool isSignUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoWidget(),
              const SizedBox(height: 48),

              /// TITLE
              Text(
                isSignUp ? 'Create Account' : 'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
              ),
              const SizedBox(height: 8),

              Text(
                isSignUp
                    ? 'Sign up to start your learning journey'
                    : 'Login to continue your progress',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
              ),

              const SizedBox(height: 32),

              /// LOGIN / SIGN UP TOGGLE
              Center(
                child: LoginToggleSwitch(
                  isLogin: !isSignUp,
                  onChanged: (val) {
                    setState(() {
                      isSignUp = !val;
                      _formKey.currentState?.reset();
                    });
                  },
                ),
              ),

              const SizedBox(height: 32),

              /// USERNAME (SIGN UP ONLY)
              if (isSignUp) ...[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Choose a unique username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],

              /// EMAIL
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              /// CONFIRM PASSWORD (SIGN UP ONLY)
              if (isSignUp) ...[
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Repeat your password',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loginProvider.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            if (isSignUp) {
                              loginProvider.registerUser(
                                context,
                                _emailController.text,
                                _passwordController.text,
                                _usernameController.text,
                              );
                            } else {
                              loginProvider.loginWithEmail(
                                context,
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          }
                        },
                  child: loginProvider.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isSignUp ? 'Create Account' : 'Login',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
}

// RIGHT SIDE: Education Theme

class RightSideVisual extends StatelessWidget {
  const RightSideVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF0F4FF), // Very light indigo/blue
            Color(0xFFD9E4FF),
            Color(0xFFAEC6FF), // Soft Blue
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating Education 3D Image Placeholder
            Container(
              height: 450,
              width: 450,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  // 3D Education/Rocket/Book illustration
                  image: NetworkImage(
                    'https://cdn3d.iconscout.com/3d/premium/thumb/online-education-4635835-3864077.png',
                  ),
                  fit: BoxFit.contain,
                ),
                // Soft shadow for depth
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4D7CFE).withOpacity(0.2),
                    blurRadius: 60,
                    spreadRadius: 10,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET HELPERS
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // School / Book Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4D7CFE).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.school_rounded,
            size: 28,
            color: Color(0xFF4D7CFE),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          "HtooChoon",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class LoginToggleSwitch extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onChanged;

  const LoginToggleSwitch({
    super.key,
    required this.isLogin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _toggleItem("Login", isLogin, () => onChanged(true)),
          _toggleItem("Sign up", !isLogin, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _toggleItem(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String iconUrl;
  final bool isBlack;
  final bool isBlue;

  const SocialButton({
    super.key,
    required this.iconUrl,
    this.isBlack = false,
    this.isBlue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isBlack
            ? Colors.black
            : (isBlue ? const Color(0xFF1877F2) : Colors.white),
        border: isBlack || isBlue
            ? null
            : Border.all(color: Colors.grey.shade300),
        boxShadow: [
          if (!isBlack && !isBlue)
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: isBlue || isBlack
          ? Image.network(iconUrl, color: Colors.white)
          : Image.network(iconUrl),
    );
  }
}
