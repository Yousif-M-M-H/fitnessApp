import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';

/// Splash screen that checks authentication status
/// Automatically navigates to appropriate screen based on auth state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  /// Check if user is authenticated and navigate accordingly
  Future<void> _checkAuthAndNavigate() async {
    // Add a small delay for better UX (show splash screen briefly)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check authentication status
    final isAuthenticated = await AuthService.isAuthenticated();

    if (!mounted) return;

    if (isAuthenticated) {
      // User is logged in, check if they have completed workout customization
      final hasWorkoutPlan = await AuthService.hasWorkoutPlan();

      if (!mounted) return;

      if (hasWorkoutPlan) {
        // User has workout plan, go directly to home screen
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // User needs to customize their workout plan first
        Navigator.pushReplacementNamed(context, AppRoutes.featureSelection);
      }
    } else {
      // User is not logged in, go to welcome screen
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo
              Icon(
                Icons.fitness_center_rounded,
                size: screenWidth * 0.25,
                color: AppColors.primaryGreen,
              ),

              SizedBox(height: screenHeight * 0.03),

              // App Name
              Text(
                'FitLife',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.5,
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              // Tagline
              Text(
                'Your Fitness Journey',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: screenHeight * 0.06),

              // Loading Indicator
              CircularProgressIndicator(
                color: AppColors.primaryGreen,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
