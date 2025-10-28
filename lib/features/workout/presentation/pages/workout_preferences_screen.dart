import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/days_selector.dart';
import '../widgets/fitness_level_selector.dart';
import '../widgets/duration_selector.dart';
import '../widgets/gender_selector_workout.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/services/workout_service.dart';

class WorkoutPreferencesScreen extends StatefulWidget {
  const WorkoutPreferencesScreen({super.key});

  @override
  State<WorkoutPreferencesScreen> createState() =>
      _WorkoutPreferencesScreenState();
}

class _WorkoutPreferencesScreenState extends State<WorkoutPreferencesScreen>
    with SingleTickerProviderStateMixin {
  int _selectedDays = 3;
  String _selectedFitnessLevel = 'Beginner';
  String _selectedGender = 'Male';
  String _selectedDuration = '45–60 min';
  bool _isLoading = false;

  final WorkoutService _workoutService = WorkoutService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
      begin: const Offset(0, 0.2),
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

  String _mapFitnessLevel(String displayLevel) {
    switch (displayLevel.toLowerCase()) {
      case 'beginner':
        return 'beginner';
      case 'intermediate':
        return 'intermediate';
      case 'advanced':
        return 'advanced';
      default:
        return 'beginner';
    }
  }

  String _mapGender(String displayGender) {
    return displayGender.toLowerCase();
  }

  String _mapDuration(String displayDuration) {
    // Maps "45–60 min" to "45-60min"
    return displayDuration.replaceAll('–', '-').replaceAll(' ', '');
  }

  Future<void> _createWorkoutPlan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final workoutPlan = await _workoutService.customizeWorkoutPlan(
        gymDaysPerWeek: _selectedDays,
        fitnessLevel: _mapFitnessLevel(_selectedFitnessLevel),
        gender: _mapGender(_selectedGender),
        sessionDuration: _mapDuration(_selectedDuration),
      );

      // Save workout plan locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('has_workout_plan', 'true');

      if (!mounted) return;

      // Navigate to home and pass workout plan
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: workoutPlan,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
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
                    Text(
                      'Workout Preferences',
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
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          Text(
                            'Tell us about your workout goals and preferences',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.038,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          DaysSelector(
                            selectedDays: _selectedDays,
                            onDaysChanged: (days) {
                              setState(() {
                                _selectedDays = days;
                              });
                            },
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          FitnessLevelSelector(
                            selectedLevel: _selectedFitnessLevel,
                            onLevelChanged: (level) {
                              setState(() {
                                _selectedFitnessLevel = level;
                              });
                            },
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          GenderSelectorWorkout(
                            selectedGender: _selectedGender,
                            onGenderChanged: (gender) {
                              setState(() {
                                _selectedGender = gender;
                              });
                            },
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          DurationSelector(
                            selectedDuration: _selectedDuration,
                            onDurationChanged: (duration) {
                              setState(() {
                                _selectedDuration = duration;
                              });
                            },
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.05),

            SizedBox(
  width: double.infinity,
  height: screenHeight * 0.065,
  child: ElevatedButton(
    onPressed: _isLoading ? null : _createWorkoutPlan,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      elevation: 0,
      disabledBackgroundColor: AppColors.primaryGreen.withValues(alpha: 0.5),
    ),
    child: _isLoading
        ? SizedBox(
            width: screenWidth * 0.05,
            height: screenWidth * 0.05,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.textDark,
              ),
            ),
          )
        : Text(
            'Create My Workout Plan',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
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
