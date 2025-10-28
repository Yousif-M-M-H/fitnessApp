import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/workout_plan_model.dart';
import '../../data/models/exercise_model.dart';
import '../widgets/exercise_item.dart';

class WorkoutDetailsScreen extends StatelessWidget {
  final DayWorkout dayWorkout;

  const WorkoutDetailsScreen({
    super.key,
    required this.dayWorkout,
  });

  String _getWorkoutDescription() {
    final type = dayWorkout.type.toLowerCase();

    if (type.contains('full body')) {
      return 'This workout targets all major muscle groups for a comprehensive full-body session. Focus on maintaining proper form and controlled movements throughout each exercise.';
    } else if (type.contains('push')) {
      return 'This push workout focuses on chest, shoulders, and triceps. Emphasize controlled movements and proper form for maximum muscle engagement.';
    } else if (type.contains('pull')) {
      return 'This pull workout targets your back and biceps. Focus on squeezing your back muscles and controlling the weight throughout each rep.';
    } else if (type.contains('legs') || type.contains('lower body')) {
      return 'This leg workout targets all major lower body muscle groups. Focus on depth in squats and maintaining balance during unilateral movements.';
    } else if (type.contains('upper body')) {
      return 'This upper body workout combines push and pull movements for a complete upper body session. Balance your effort across all exercises.';
    } else if (type.contains('core') || type.contains('cardio')) {
      return 'This session combines core strengthening and cardiovascular conditioning. Focus on engaging your core and maintaining a steady pace.';
    } else if (type.contains('recovery')) {
      return 'Active recovery helps your body heal while staying mobile. Take it easy and focus on light movement and stretching.';
    }

    return 'Complete each exercise with proper form and controlled movements. Rest adequately between sets to maintain quality.';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Parse exercises
    final exercises = dayWorkout.exercises
        .map((exerciseString) => ExerciseModel.fromString(exerciseString))
        .toList();

    return Scaffold(
      body: Container(
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
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.textPrimary,
                          size: screenWidth * 0.06,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Text(
                      'Workout Details',
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
                      // Workout title
                      Text(
                        dayWorkout.type,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Workout description
                      Text(
                        _getWorkoutDescription(),
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Exercises section
                      Text(
                        'Exercises',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Exercise list
                      ...exercises.map((exercise) {
                        return ExerciseItem(
                          exercise: exercise,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        );
                      }),

                      SizedBox(height: screenHeight * 0.02),
                    ],
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
