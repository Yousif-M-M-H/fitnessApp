import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class FitnessLevelSelector extends StatelessWidget {
  final String selectedLevel;
  final Function(String) onLevelChanged;
  final double screenWidth;
  final double screenHeight;

  const FitnessLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelChanged,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final levels = [
      {'label': 'Beginner', 'icon': Icons.directions_walk, 'desc': 'New to fitness'},
      {'label': 'Intermediate', 'icon': Icons.directions_run, 'desc': 'Regular workouts'},
      {'label': 'Advanced', 'icon': Icons.fitness_center, 'desc': 'Experienced athlete'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your fitness level?',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        ...levels.map((level) {
          final isSelected = selectedLevel == level['label'];
          return Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.012),
            child: GestureDetector(
              onTap: () => onLevelChanged(level['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen.withValues(alpha: 0.15)
                      : AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.inputBorder.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGreen.withValues(alpha: 0.2)
                            : AppColors.inputBorder.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      child: Icon(
                        level['icon'] as IconData,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textSecondary,
                        size: screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level['label'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.002),
                          Text(
                            level['desc'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.034,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                        size: screenWidth * 0.055,
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
