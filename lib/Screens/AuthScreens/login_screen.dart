import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Screens/UserScreens/plan_selection_screen.dart';
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: AuthFormLeft(),
                  ),
                ),
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
  String selectedRole = 'user';

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
      builder: (context, loginProvider, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  isSignUp ? 'Create Account' : 'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),

                Text(
                  isSignUp ? 'Sign up to get started' : 'Login to continue',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 32),

                /// LOGIN / SIGN UP TOGGLE
                ToggleButtons(
                  isSelected: [!isSignUp, isSignUp],
                  onPressed: (index) {
                    setState(() {
                      isSignUp = index == 1;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Login'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Sign Up'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// USERNAME (SIGN UP ONLY)
                if (isSignUp)
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                if (isSignUp) const SizedBox(height: 16),

                /// EMAIL
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 16),

                /// PASSWORD
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                /// CONFIRM PASSWORD (SIGN UP ONLY)
                if (isSignUp) const SizedBox(height: 16),

                if (isSignUp)
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),

                /// ROLE SELECTOR (SIGN UP ONLY)
                if (isSignUp) const SizedBox(height: 16),

                if (isSignUp)
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Account Type',
                      prefixIcon: Icon(Icons.school),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'user',
                        child: Text('User (student/teacher/mentor)'),
                      ),

                      DropdownMenuItem(
                        value: 'org',
                        child: Text('Organization'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),

                const SizedBox(height: 32),

                /// SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isSignUp) {
                        // SIGN UP LOGIC
                        print('Username: ${_usernameController.text}');
                        print('Email: ${_emailController.text}');
                        print('Role: $selectedRole');
                        loginProvider.registerUser(
                          context,
                          _emailController.text,
                          _passwordController.text,
                          selectedRole,
                          _usernameController.text,
                        );
                      } else {
                        // LOGIN LOGIC
                        print('Login: ${_emailController.text}');
                        loginProvider.loginWithEmail(
                          context,
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                    child: Text(
                      isSignUp ? 'Create Account' : 'Login',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword ? obscureText : false,
        decoration: InputDecoration(
          icon: Icon(icon),
          labelText: label,
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
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
