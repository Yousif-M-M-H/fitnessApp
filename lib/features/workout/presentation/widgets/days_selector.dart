import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DaysSelector extends StatelessWidget {
  final int selectedDays;
  final Function(int) onDaysChanged;
  final double screenWidth;
  final double screenHeight;

  const DaysSelector({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many days a week would you prefer to go to the gym?',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            border: Border.all(
              color: AppColors.inputBorder.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Days per week',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    ),
                    child: Text(
                      '$selectedDays',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.primaryGreen,
                  inactiveTrackColor: AppColors.inputBorder.withValues(alpha: 0.3),
                  thumbColor: AppColors.primaryGreen,
                  overlayColor: AppColors.primaryGreen.withValues(alpha: 0.2),
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: screenWidth * 0.025,
                  ),
                  trackHeight: screenHeight * 0.006,
                ),
                child: Slider(
                  value: selectedDays.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  onChanged: (value) => onDaysChanged(value.toInt()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final day = index + 1;
                  return Text(
                    '$day',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.032,
                      color: selectedDays == day
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                      fontWeight: selectedDays == day
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
