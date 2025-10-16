import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class GenderSelectorWorkout extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderChanged;
  final double screenWidth;
  final double screenHeight;

  const GenderSelectorWorkout({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your gender?',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        Row(
          children: [
            Expanded(
              child: _GenderOption(
                gender: 'Male',
                icon: Icons.male,
                isSelected: selectedGender == 'Male',
                onTap: () => onGenderChanged('Male'),
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: _GenderOption(
                gender: 'Female',
                icon: Icons.female,
                isSelected: selectedGender == 'Female',
                onTap: () => onGenderChanged('Female'),
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String gender;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;
  final double screenHeight;

  const _GenderOption({
    required this.gender,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
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
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
              size: screenWidth * 0.1,
            ),
            SizedBox(height: screenHeight * 0.008),
            Text(
              gender,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
