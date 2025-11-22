import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/feature_item.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const WelcomeView(),
    );
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: screenHeight * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.08),

                  // Hero Section - App Icon and Name
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth * 0.28,
                          height: screenWidth * 0.28,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryGreen,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            size: screenWidth * 0.15,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
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
                        Text(
                          'Transform Your Body, Mind & Life',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.042,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // Features Section
                  FeatureItem(
                    icon: Icons.restaurant_menu,
                    title: 'Personalized Nutrition',
                    description: 'Get customized meal plans based on your goals and preferences.',
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FeatureItem(
                    icon: Icons.fitness_center,
                    title: 'Custom Workouts',
                    description: 'Personalized workout plans designed for your fitness level.',
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FeatureItem(
                    icon: Icons.trending_up,
                    title: 'Track Progress',
                    description: 'Monitor your journey with detailed analytics and insights.',
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<OnboardingCubit>().navigateToSignup();
                        Navigator.pushNamed(context, AppRoutes.signUp);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.textDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.048,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Already have an account
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.read<OnboardingCubit>().navigateToLogin();
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.06,
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.038,
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.038,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
