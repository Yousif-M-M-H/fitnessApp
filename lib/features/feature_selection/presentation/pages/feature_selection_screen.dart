import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class FeatureSelectionScreen extends StatefulWidget {
  const FeatureSelectionScreen({super.key});

  @override
  State<FeatureSelectionScreen> createState() => _FeatureSelectionScreenState();
}

class _FeatureSelectionScreenState extends State<FeatureSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkGreenBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),

                // Header Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Welcome Icon
                      Container(
                        width: screenWidth * 0.15,
                        height: screenWidth * 0.15,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.celebration_outlined,
                          color: AppColors.primaryGreen,
                          size: screenWidth * 0.08,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      // Welcome Text
                      Text(
                        'Welcome Aboard!',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.008),

                      // Subtitle
                      Text(
                        'Choose your fitness journey',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Feature Cards
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Nutrition Calculator Card
                          Expanded(
                            child: _FeatureCard(
                              title: 'Nutrition Calculator',
                              description: 'Track your daily calories, macros, and build healthy eating habits',
                              icon: Icons.restaurant_menu_rounded,
                              gradientColors: [
                                AppColors.tealAccent,
                                AppColors.tealAccent.withValues(alpha: 0.7),
                              ],
                              onTap: () {
                                _handleFeatureSelection(context, 'nutrition');
                              },
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Customize Workout Plan Card
                          Expanded(
                            child: _FeatureCard(
                              title: 'Customize My Workout Plan',
                              description: 'Create personalized workout routines tailored to your goals',
                              icon: Icons.fitness_center_rounded,
                              gradientColors: [
                                AppColors.runnerGreen,
                                AppColors.runnerGreen.withValues(alpha: 0.7),
                              ],
                              onTap: () {
                                _handleFeatureSelection(context, 'workout');
                              },
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                // Skip for now button
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigate to home screen or skip this step
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Skip feature - Navigate to home',
                            style: GoogleFonts.poppins(),
                          ),
                          backgroundColor: AppColors.darkGreenBackground,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text(
                      'Skip for now',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.036,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleFeatureSelection(BuildContext context, String feature) {
    if (feature == 'nutrition') {
      Navigator.pushNamed(context, AppRoutes.nutritionInput);
    } else if (feature == 'workout') {
      Navigator.pushNamed(context, AppRoutes.workoutPreferences);
    }
  }
}

class _FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final double screenWidth;
  final double screenHeight;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
            ),
            borderRadius: BorderRadius.circular(widget.screenWidth * 0.05),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors[0].withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.screenWidth * 0.05),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -widget.screenWidth * 0.1,
                  right: -widget.screenWidth * 0.1,
                  child: Container(
                    width: widget.screenWidth * 0.4,
                    height: widget.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -widget.screenWidth * 0.15,
                  left: -widget.screenWidth * 0.15,
                  child: Container(
                    width: widget.screenWidth * 0.5,
                    height: widget.screenWidth * 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(widget.screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section (Icon and Text)
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon
                            Container(
                              width: widget.screenWidth * 0.12,
                              height: widget.screenWidth * 0.12,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(widget.screenWidth * 0.025),
                              ),
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: widget.screenWidth * 0.07,
                              ),
                            ),

                            SizedBox(height: widget.screenHeight * 0.012),

                            // Title
                            Text(
                              widget.title,
                              style: GoogleFonts.poppins(
                                fontSize: widget.screenWidth * 0.048,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            SizedBox(height: widget.screenHeight * 0.008),

                            // Description
                            Text(
                              widget.description,
                              style: GoogleFonts.poppins(
                                fontSize: widget.screenWidth * 0.034,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w400,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Arrow indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(widget.screenWidth * 0.018),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: widget.screenWidth * 0.05,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
