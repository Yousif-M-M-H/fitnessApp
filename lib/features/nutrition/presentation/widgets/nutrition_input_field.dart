import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class NutritionInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String suffix;
  final TextInputType keyboardType;
  final double screenWidth;
  final double screenHeight;

  const NutritionInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.suffix,
    required this.keyboardType,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            border: Border.all(
              color: AppColors.inputBorder.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: screenWidth * 0.04,
              ),
              prefixIcon: Icon(
                icon,
                color: AppColors.primaryGreen,
                size: screenWidth * 0.06,
              ),
              suffixText: suffix,
              suffixStyle: GoogleFonts.poppins(
                color: AppColors.textSecondary,
                fontSize: screenWidth * 0.038,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
