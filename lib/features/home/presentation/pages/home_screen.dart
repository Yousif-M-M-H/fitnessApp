import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../widgets/health_metrics_card.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/weekly_progress_card.dart';
import '../widgets/nutrition_tab_widget.dart';
import '../../../account/presentation/pages/account_screen.dart';
import '../../../workout/data/models/workout_plan_model.dart';
import '../../../workout/data/services/workout_service.dart';
import '../../../workout/presentation/pages/workout_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  final WorkoutPlanModel? workoutPlan;

  const HomeScreen({super.key, this.workoutPlan});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  WorkoutPlanModel? _workoutPlan;
  bool _isLoadingWorkout = false;
  final WorkoutService _workoutService = WorkoutService();

  // Nutrition data for Progress tab
  bool _hasNutritionData = false;
  int _dailyCalories = 0;

  // Workout progress tracking
  int _completedWorkouts = 0;
  int _totalWorkouts = 0;

  @override
  void initState() {
    super.initState();
    _workoutPlan = widget.workoutPlan;
    // If no workout plan provided, try to load it
    if (_workoutPlan == null) {
      _loadWorkoutPlan();
    }
    _loadNutritionData();
    _loadWeeklyProgress();
  }

  Future<void> _loadNutritionData() async {
    final nutritionData = await AuthService.getNutritionData();
    if (mounted) {
      final calories = nutritionData['dailyCalories'];
      if (calories != null && calories > 0) {
        setState(() {
          _hasNutritionData = true;
          _dailyCalories = calories;
        });
      }
    }
  }

  String _getWeekKey() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadWeeklyProgress() async {
    final userData = await AuthService.getUserData();
    final userId = userData['userId'];
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final weekKey = _getWeekKey();
    final storageKey = 'weekly_progress_${userId}_$weekKey';

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    int completed = 0;
    int total = 0;

    // Count completed and total workouts based on the workout plan
    for (final day in days) {
      final dayIndex = days.indexOf(day);
      DayWorkout? dayWorkout;

      if (_workoutPlan != null && dayIndex < _workoutPlan!.weeklyPlan.length) {
        dayWorkout = _workoutPlan!.weeklyPlan[dayIndex];
      }

      // Only count non-rest days as total workouts
      if (dayWorkout != null && !dayWorkout.type.toLowerCase().contains('rest')) {
        total++;
        final isCompleted = prefs.getBool('${storageKey}_$day') ?? false;
        if (isCompleted) {
          completed++;
        }
      }
    }

    if (mounted) {
      setState(() {
        _completedWorkouts = completed;
        _totalWorkouts = total;
      });
    }
  }

  Future<void> _loadWorkoutPlan() async {
    // Check if user has workout preferences saved
    final hasWorkoutPlan = await AuthService.hasWorkoutPlan();

    if (!hasWorkoutPlan) return;

    setState(() {
      _isLoadingWorkout = true;
    });

    try {
      final preferences = await AuthService.getWorkoutPreferences();

      // Fetch workout plan using saved preferences
      final workoutPlan = await _workoutService.customizeWorkoutPlan(
        gymDaysPerWeek: preferences['gymDaysPerWeek'] ?? 3,
        fitnessLevel: preferences['activityLevel'] ?? 'beginner',
        gender: 'male', // Default, could be saved in preferences too
        sessionDuration: preferences['sessionDuration'] ?? '45-60min',
      );

      if (mounted) {
        setState(() {
          _workoutPlan = workoutPlan;
          _isLoadingWorkout = false;
        });
        // Reload weekly progress now that we have the workout plan
        _loadWeeklyProgress();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingWorkout = false;
        });
      }
      debugPrint('Error loading workout plan: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Reload data when switching to Progress tab
    if (index == 2) {
      _loadNutritionData(); // Reload nutrition data
      _loadWeeklyProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_selectedIndex == 0) {
      // Home tab - Show nutrition calculator or results
      body = NutritionTabWidget(
        onNutritionUpdated: _loadNutritionData,
      );
    } else if (_selectedIndex == 1) {
      // Workouts tab
      if (_isLoadingWorkout) {
        // Show loading indicator while fetching workout plan
        body = Container(
          decoration: BoxDecoration(gradient: AppColors.darkGradient),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          ),
        );
      } else if (_workoutPlan != null) {
        body = WorkoutPlanScreen(workoutPlan: _workoutPlan!);
      } else {
        body = _buildPlaceholder();
      }
    } else if (_selectedIndex == 2) {
      // Progress tab
      body = _buildProgressTab();
    } else {
      body = _buildPlaceholder();
    }

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: body,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProgressTab() {
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
              child: Center(
                child: Text(
                  'Fitness Tracker',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Health Metrics Section
                    Text(
                      'Health Metrics',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    if (_hasNutritionData)
                      HealthMetricsCard(
                        label: 'Daily Calories',
                        value: _dailyCalories.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        ),
                        subtitle: 'kcal',
                        subtitleColor: AppColors.textSecondary,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      )
                    else
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.045),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                          border: Border.all(
                            color: AppColors.inputBorder.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.restaurant_menu_outlined,
                              color: AppColors.primaryGreen,
                              size: screenWidth * 0.1,
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              'Calculate Your Nutrition',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Go to the Nutrition tab to calculate your daily calorie needs',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: screenHeight * 0.025),

                    // Daily Progress Card
                    DailyProgressCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      completedWorkouts: _completedWorkouts,
                      totalWorkouts: _totalWorkouts,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Weekly Progress Section
                    Text(
                      'Weekly Progress',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    WeeklyProgressCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      workoutPlan: _workoutPlan,
                      onProgressUpdated: () {
                        _loadWeeklyProgress();
                      },
                    ),

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

 
Widget _buildPlaceholder() {
  if (_selectedIndex == 3) {
    return const AccountScreen();
  }

  return Container(
    decoration: BoxDecoration(
      gradient: AppColors.darkGradient,
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 80,
            color: AppColors.primaryGreen,
          ),
          SizedBox(height: 20),
          Text(
            'Coming Soon',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'This section is under development',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildBottomNavigationBar() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGreenBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.restaurant_menu_outlined,
                label: 'Nutrition',
                index: 0,
                screenWidth: screenWidth,
              ),
              _buildNavItem(
                icon: Icons.fitness_center_outlined,
                label: 'Workouts',
                index: 1,
                screenWidth: screenWidth,
              ),
              _buildNavItem(
                icon: Icons.bar_chart_rounded,
                label: 'Progress',
                index: 2,
                screenWidth: screenWidth,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'Account',
                index: 3,
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required double screenWidth,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
              size: screenWidth * 0.065,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.03,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}