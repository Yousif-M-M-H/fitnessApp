import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class WeeklyProgressCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const WeeklyProgressCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final weekData = [
      {'day': 'Mon', 'completed': false},
      {'day': 'Tue', 'completed': true},
      {'day': 'Wed', 'completed': true},
      {'day': 'Thu', 'completed': true},
      {'day': 'Fri', 'completed': true},
      {'day': 'Sat', 'completed': false},
      {'day': 'Sun', 'completed': false},
    ];

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Workouts This Week',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '4',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    '+20%',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: weekData.map((data) {
              return _buildDayBar(
                day: data['day'] as String,
                completed: data['completed'] as bool,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBar({required String day, required bool completed}) {
    return Column(
      children: [
        Container(
          width: screenWidth * 0.095,
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            color: completed
                ? AppColors.primaryGreen.withValues(alpha: 0.3)
                : AppColors.inputBorder.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            border: Border.all(
              color: completed
                  ? AppColors.primaryGreen
                  : AppColors.inputBorder.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: completed
              ? Center(
                  child: Icon(
                    Icons.check,
                    color: AppColors.primaryGreen,
                    size: screenWidth * 0.045,
                  ),
                )
              : null,
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          day,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.03,
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