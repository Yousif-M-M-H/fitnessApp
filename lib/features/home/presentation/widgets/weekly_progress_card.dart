import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../workout/data/models/workout_plan_model.dart';
import '../../../workout/presentation/pages/workout_details_screen.dart';

class WeeklyProgressCard extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final WorkoutPlanModel? workoutPlan;
  final VoidCallback? onProgressUpdated;

  const WeeklyProgressCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    this.workoutPlan,
    this.onProgressUpdated,
  });

  @override
  State<WeeklyProgressCard> createState() => _WeeklyProgressCardState();
}

class _WeeklyProgressCardState extends State<WeeklyProgressCard> {
  Map<String, bool> _weekData = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };

  String? _userId;
  String _currentWeekKey = '';

  @override
  void initState() {
    super.initState();
    _loadWeeklyProgress();
  }

  /// Get the current week's Monday as a key for storage
  String _getWeekKey() {
    final now = DateTime.now();
    // Get Monday of current week
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadWeeklyProgress() async {
    final userData = await AuthService.getUserData();
    _userId = userData['userId'];
    _currentWeekKey = _getWeekKey();

    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final storageKey = 'weekly_progress_${_userId}_$_currentWeekKey';

    // Load each day's completion status
    final Map<String, bool> loadedData = {};
    for (final day in _weekData.keys) {
      final completed = prefs.getBool('${storageKey}_$day') ?? false;
      loadedData[day] = completed;
    }

    if (mounted) {
      setState(() {
        _weekData = loadedData;
      });
    }
  }

  DayWorkout? _getWorkoutForDay(String day) {
    if (widget.workoutPlan == null) return null;

    final dayIndex = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].indexOf(day);
    if (dayIndex == -1) return null;

    // Map day to workout schedule
    final weeklyPlan = widget.workoutPlan!.weeklyPlan;
    if (dayIndex < weeklyPlan.length) {
      return weeklyPlan[dayIndex];
    }

    return null;
  }

  void _navigateToWorkoutDetails(String day) {
    final dayWorkout = _getWorkoutForDay(day);

    if (dayWorkout == null || dayWorkout.type.toLowerCase().contains('rest')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$day is a rest day',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.textSecondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailsScreen(
          dayWorkout: dayWorkout,
          dayName: day,
        ),
      ),
    ).then((_) {
      // Reload progress when coming back
      _loadWeeklyProgress();
      // Notify parent to update overall progress
      widget.onProgressUpdated?.call();
    });
  }

  int get _completedCount => _weekData.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: EdgeInsets.all(widget.screenWidth * 0.045),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(widget.screenWidth * 0.04),
        border: Border.all(
          color: AppColors.inputBorder.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workouts This Week',
                style: GoogleFonts.poppins(
                  fontSize: widget.screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$_completedCount',
                    style: GoogleFonts.poppins(
                      fontSize: widget.screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: widget.screenWidth * 0.02),
                  Text(
                    '/7',
                    style: GoogleFonts.poppins(
                      fontSize: widget.screenWidth * 0.038,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: widget.screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: days.map((day) {
              final hasWorkout = _getWorkoutForDay(day) != null &&
                  !(_getWorkoutForDay(day)!.type.toLowerCase().contains('rest'));
              return _buildDayBar(
                day: day,
                completed: _weekData[day] ?? false,
                hasWorkout: hasWorkout,
                onTap: () => _navigateToWorkoutDetails(day),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBar({
    required String day,
    required bool completed,
    required bool hasWorkout,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: widget.screenWidth * 0.095,
            height: widget.screenHeight * 0.06,
            decoration: BoxDecoration(
              color: completed
                  ? AppColors.primaryGreen.withValues(alpha: 0.3)
                  : hasWorkout
                      ? AppColors.inputBorder.withValues(alpha: 0.2)
                      : AppColors.inputBorder.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(widget.screenWidth * 0.02),
              border: Border.all(
                color: completed
                    ? AppColors.primaryGreen
                    : hasWorkout
                        ? AppColors.inputBorder.withValues(alpha: 0.5)
                        : AppColors.inputBorder.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: completed
                ? Center(
                    child: Icon(
                      Icons.check,
                      color: AppColors.primaryGreen,
                      size: widget.screenWidth * 0.045,
                    ),
                  )
                : hasWorkout
                    ? Center(
                        child: Icon(
                          Icons.fitness_center,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                          size: widget.screenWidth * 0.04,
                        ),
                      )
                    : Center(
                        child: Text(
                          'R',
                          style: GoogleFonts.poppins(
                            fontSize: widget.screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
          ),
        ),
        SizedBox(height: widget.screenHeight * 0.01),
        Text(
          day,
          style: GoogleFonts.poppins(
            fontSize: widget.screenWidth * 0.03,
            fontWeight: FontWeight.w500,
            color: completed
                ? AppColors.textPrimary
                : AppColors.textSecondary.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
