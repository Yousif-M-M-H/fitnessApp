import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/nutrition_response_model.dart';
import '../widgets/nutrition_result_card.dart';

class NutritionResultsScreen extends StatefulWidget {
  final NutritionData? nutritionData;
  final bool showBackButton;
  final VoidCallback? onRecalculate;
  final bool showCustomizeWorkout;

  const NutritionResultsScreen({
    super.key,
    this.nutritionData,
    this.showBackButton = true,
    this.onRecalculate,
    this.showCustomizeWorkout = true,
  });

  @override
  State<NutritionResultsScreen> createState() => _NutritionResultsScreenState();
}

class _NutritionResultsScreenState extends State<NutritionResultsScreen>
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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
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

    // Get nutrition data from widget or route arguments
    final nutritionData = widget.nutritionData ??
        ModalRoute.of(context)!.settings.arguments as NutritionData;

    return Scaffold(
      backgroundColor: AppColors.darkGreenBackground,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    if (widget.showBackButton) ...[
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textPrimary,
                          size: screenWidth * 0.06,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                    ],
                    Text(
                      'Your Nutrition Plan',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.01),

                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.04,
                              ),
                              border: Border.all(
                                color: AppColors.primaryGreen.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius: BorderRadius.circular(
                                      screenWidth * 0.02,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: AppColors.textDark,
                                    size: screenWidth * 0.06,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Calculation Complete!',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.042,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryGreen,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.005),
                                      Text(
                                        'Your daily nutritional targets',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          Text(
                            'Daily Targets',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          NutritionResultCard(
                            icon: Icons.local_fire_department_rounded,
                            label: 'Calories Intake',
                            value: nutritionData.dailyCalories.toString(),
                            unit: 'kcal',
                            subtitle: 'per day',
                            color: AppColors.coralBackground,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            delay: 200,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          NutritionResultCard(
                            icon: Icons.restaurant_rounded,
                            label: 'Protein Intake',
                            value: nutritionData.proteinIntake.toString(),
                            unit: 'g',
                            subtitle: 'per day',
                            color: AppColors.primaryGreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            delay: 400,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          NutritionResultCard(
                            icon: Icons.rice_bowl_rounded,
                            label: 'Carb Intake',
                            value: nutritionData.carbIntake.toString(),
                            unit: 'g',
                            subtitle: 'per day',
                            color: AppColors.tealAccent,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            delay: 600,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          NutritionResultCard(
                            icon: Icons.opacity_rounded,
                            label: 'Fat Intake',
                            value: nutritionData.fatIntake.toString(),
                            unit: 'g',
                            subtitle: 'per day',
                            color: AppColors.runnerGreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            delay: 800,
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.045),
                            decoration: BoxDecoration(
                              color: AppColors.inputBackground,
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.04,
                              ),
                              border: Border.all(
                                color: AppColors.inputBorder.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColors.primaryGreen,
                                  size: screenWidth * 0.055,
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'BMR: ${nutritionData.bmr} kcal | TDEE: ${nutritionData.tdee} kcal',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.008),
                                      Text(
                                        'These values are calculated based on your age, weight, height, gender, activity level, and fitness goals. Adjust your intake based on your progress.',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          color: AppColors.textSecondary,
                                          height: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Show full width recalculate button OR row with both buttons
                          widget.showCustomizeWorkout
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: screenHeight * 0.06,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            if (widget.onRecalculate != null) {
                                              widget.onRecalculate!();
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.refresh_rounded,
                                            size: screenWidth * 0.05,
                                          ),
                                          label: Text(
                                            'Recalculate',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.038,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.primaryGreen,
                                            side: BorderSide(
                                              color: AppColors.primaryGreen,
                                              width: 1.5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                screenWidth * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.03),
                                    Expanded(
                                      child: SizedBox(
                                        height: screenHeight * 0.06,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRoutes.workoutPreferences,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.fitness_center_rounded,
                                            size: screenWidth * 0.05,
                                          ),
                                          label: Text(
                                            'Customize Workout',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.032,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryGreen,
                                            foregroundColor: AppColors.textDark,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                screenWidth * 0.04,
                                              ),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.06,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      if (widget.onRecalculate != null) {
                                        widget.onRecalculate!();
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.refresh_rounded,
                                      size: screenWidth * 0.05,
                                    ),
                                    label: Text(
                                      'Recalculate',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.042,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primaryGreen,
                                      side: BorderSide(
                                        color: AppColors.primaryGreen,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          screenWidth * 0.04,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                          SizedBox(height: screenHeight * 0.03),
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
}
