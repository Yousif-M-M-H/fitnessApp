import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ActivityLevelSelector extends StatelessWidget {
  final String selectedLevel;
  final Function(String) onLevelChanged;
  final double screenWidth;
  final double screenHeight;

  const ActivityLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final levels = [
      {
        'value': 'sedentary',
        'label': 'Sedentary',
        'desc': 'Little or no exercise',
        'icon': Icons.weekend_rounded,
      },
      {
        'value': 'light',
        'label': 'Light',
        'desc': 'Exercise 1-3 times/week',
        'icon': Icons.directions_walk_rounded,
      },
      {
        'value': 'moderate',
        'label': 'Moderate',
        'desc': 'Exercise 4-5 times/week',
        'icon': Icons.directions_run_rounded,
      },
      {
        'value': 'active',
        'label': 'Active',
        'desc': 'Exercise 6-7 times/week',
        'icon': Icons.fitness_center_rounded,
      },
      {
        'value': 'very_active',
        'label': 'Very Active',
        'desc': 'Physical job + exercise',
        'icon': Icons.local_fire_department_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Level',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),

        // Grid layout with 2 columns
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: screenWidth * 0.025,
            mainAxisSpacing: screenHeight * 0.012,
            childAspectRatio: 2.2,
          ),
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final level = levels[index];
            final isSelected = selectedLevel == level['value'];

            return GestureDetector(
              onTap: () => onLevelChanged(level['value'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen.withValues(alpha: 0.15)
                      : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(screenWidth * 0.035),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.inputBorder.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.085,
                      height: screenWidth * 0.085,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGreen.withValues(alpha: 0.2)
                            : AppColors.inputBorder.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          screenWidth * 0.02,
                        ),
                      ),
                      child: Icon(
                        level['icon'] as IconData,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textSecondary,
                        size: screenWidth * 0.045,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        level['label'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.036,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
