import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/workout_plan_model.dart';
import '../pages/workout_details_screen.dart';

class WorkoutDayCard extends StatelessWidget {
  final DayWorkout dayWorkout;
  final double screenWidth;
  final double screenHeight;

  const WorkoutDayCard({
    super.key,
    required this.dayWorkout,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(
          color: AppColors.inputBorder.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailsScreen(
                dayWorkout: dayWorkout,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              // Day number badge
              Container(
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Center(
                  child: Text(
                    'Day\n${dayWorkout.day}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.032,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.035),
              // Workout info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayWorkout.type,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.004),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: AppColors.textSecondary,
                          size: screenWidth * 0.038,
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          dayWorkout.duration,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.034,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Icon(
                          Icons.fitness_center,
                          color: AppColors.textSecondary,
                          size: screenWidth * 0.038,
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          '${dayWorkout.exercises.length} exercises',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.034,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryGreen,
                size: screenWidth * 0.045,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
