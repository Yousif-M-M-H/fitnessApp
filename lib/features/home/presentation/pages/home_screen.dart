import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/health_metrics_card.dart';
import '../widgets/daily_progress_card.dart';
import '../widgets/weekly_progress_card.dart';
import '../widgets/total_workouts_chart.dart';
import '../../../account/presentation/pages/account_screen.dart';
import '../../../workout/data/models/workout_plan_model.dart';
import '../../../workout/presentation/pages/workout_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  final WorkoutPlanModel? workoutPlan;

  const HomeScreen({super.key, this.workoutPlan});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_selectedIndex == 1 && widget.workoutPlan != null) {
      body = WorkoutPlanScreen(workoutPlan: widget.workoutPlan!);
    } else if (_selectedIndex == 2) {
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile Icon
                  Container(
                    width: screenWidth * 0.11,
                    height: screenWidth * 0.11,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.textPrimary,
                      size: screenWidth * 0.06,
                    ),
                  ),

                  // Title
                  Text(
                    'Fitness Tracker',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  // Settings Icon
                  Container(
                    width: screenWidth * 0.11,
                    height: screenWidth * 0.11,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings_outlined,
                      color: AppColors.textPrimary,
                      size: screenWidth * 0.06,
                    ),
                  ),
                ],
              ),
            ),

            // Tab Selector
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(screenWidth * 0.08),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.018,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.08,
                            ),
                          ),
                          child: Text(
                            'Goals & Progress',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.038,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.018,
                          ),
                          child: Text(
                            'Next Workout',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.038,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

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

                    Row(
                      children: [
                        Expanded(
                          child: HealthMetricsCard(
                            label: 'BMI',
                            value: '22.5',
                            subtitle: 'Healthy',
                            subtitleColor: AppColors.primaryGreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: HealthMetricsCard(
                            label: 'Daily Calories',
                            value: '2,100',
                            subtitle: 'kcal',
                            subtitleColor: AppColors.textSecondary,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Daily Progress Card
                    DailyProgressCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
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
                    ),

                    SizedBox(height: screenHeight * 0.025),

                    // Total Workouts Chart
                    TotalWorkoutsChart(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
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
                icon: Icons.home_outlined,
                label: 'Home',
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