import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/models/workout_plan_model.dart';
import '../../data/models/exercise_model.dart';
import '../widgets/exercise_item.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final DayWorkout dayWorkout;
  final String dayName; // e.g., 'Mon', 'Tue', etc.

  const WorkoutDetailsScreen({
    super.key,
    required this.dayWorkout,
    required this.dayName,
  });

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool _isCompleted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfCompleted();
  }

  String _getWeekKey() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  Future<void> _checkIfCompleted() async {
    final userData = await AuthService.getUserData();
    final userId = userData['userId'];
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final weekKey = _getWeekKey();
    final storageKey = 'weekly_progress_${userId}_${weekKey}_${widget.dayName}';
    final completed = prefs.getBool(storageKey) ?? false;

    if (mounted) {
      setState(() {
        _isCompleted = completed;
      });
    }
  }

  Future<void> _markAsCompleted() async {
    setState(() {
      _isLoading = true;
    });

    final userData = await AuthService.getUserData();
    final userId = userData['userId'];
    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final weekKey = _getWeekKey();
    final storageKey = 'weekly_progress_${userId}_${weekKey}_${widget.dayName}';
    await prefs.setBool(storageKey, true);

    if (mounted) {
      setState(() {
        _isCompleted = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Great job! Workout completed! 💪',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _getWorkoutDescription() {
    final type = widget.dayWorkout.type.toLowerCase();

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
    final exercises = widget.dayWorkout.exercises
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
                    Expanded(
                      child: Text(
                        '${widget.dayName} Workout',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (_isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primaryGreen,
                              size: screenWidth * 0.04,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              'Done',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
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
                        widget.dayWorkout.type,
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

                      SizedBox(height: screenHeight * 0.03),

                      // Finish Workout Button
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton.icon(
                          onPressed: _isCompleted || _isLoading
                              ? null
                              : _markAsCompleted,
                          icon: Icon(
                            _isCompleted
                                ? Icons.check_circle
                                : Icons.fitness_center,
                            size: screenWidth * 0.055,
                          ),
                          label: Text(
                            _isCompleted ? 'Workout Completed' : 'Finish Workout',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isCompleted
                                ? AppColors.primaryGreen.withValues(alpha: 0.5)
                                : AppColors.primaryGreen,
                            foregroundColor: AppColors.textDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.04,
                              ),
                            ),
                            elevation: 0,
                            disabledBackgroundColor:
                                AppColors.primaryGreen.withValues(alpha: 0.3),
                            disabledForegroundColor: AppColors.textDark,
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),
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
