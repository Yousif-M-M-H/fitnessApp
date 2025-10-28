import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class HealthMetricsCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color subtitleColor;
  final double screenWidth;
  final double screenHeight;

  const HealthMetricsCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}