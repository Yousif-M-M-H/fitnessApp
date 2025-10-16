import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DurationSelector extends StatelessWidget {
  final String selectedDuration;
  final Function(String) onDurationChanged;
  final double screenWidth;
  final double screenHeight;

  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final durations = [
      {'label': '30–45 min', 'icon': Icons.schedule},
      {'label': '45–60 min', 'icon': Icons.schedule},
      {'label': '60–90 min', 'icon': Icons.schedule},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How long do you want your training session to be?',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        Wrap(
          spacing: screenWidth * 0.03,
          runSpacing: screenHeight * 0.012,
          children: durations.map((duration) {
            final isSelected = selectedDuration == duration['label'];
            return GestureDetector(
              onTap: () => onDurationChanged(duration['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.018,
                ),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      duration['icon'] as IconData,
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary,
                      size: screenWidth * 0.05,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      duration['label'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
