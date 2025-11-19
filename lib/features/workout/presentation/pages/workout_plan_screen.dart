import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/workout_plan_model.dart';
import '../widgets/workout_day_card.dart';
import '../widgets/workout_summary_card.dart';

class WorkoutPlanScreen extends StatelessWidget {
  final WorkoutPlanModel workoutPlan;

  const WorkoutPlanScreen({
    super.key,
    required this.workoutPlan,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.darkGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: AppColors.primaryGreen,
                    size: screenWidth * 0.07,
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    'Your Workout Plan',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card
                    WorkoutSummaryCard(
                      summary: workoutPlan.summary,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Weekly Plan Section
                    Text(
                      'Weekly Schedule',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.048,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // Workout Days
                    ...workoutPlan.weeklyPlan.map((dayWorkout) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                        child: WorkoutDayCard(
                          dayWorkout: dayWorkout,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                      );
                    }),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
