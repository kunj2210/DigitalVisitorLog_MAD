import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';

/// SplashScreen with Session Persistence
///
/// Lab 8 Step 5: After the splash delay, this screen checks Firebase Auth
/// to determine if a user is already logged in.
/// - If logged in  → Navigate to DashboardScreen (skip Login)
/// - If not logged in → Navigate to LoginScreen
///
/// Uses pushReplacement so the splash is removed from the navigation stack.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Fade-in animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    _checkSessionAndNavigate();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Lab 8: Session Persistence Logic
  /// Checks Firebase Auth current user to decide navigation target.
  Future<void> _checkSessionAndNavigate() async {
    // Splash delay
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    // Lab 8: Check login state via Firebase Auth
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // User is already logged in – skip Login screen
      debugPrint('SplashScreen: User logged in (${currentUser.email}) → Dashboard');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      // No active session – go to Login
      debugPrint('SplashScreen: No active session → Login');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/app_logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              // App Name
              const Text(
                'Digital Visitor Log',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Smart. Secure. Simple.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Color(0xFF475569),
                strokeWidth: 2.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
