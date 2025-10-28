import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/workout_plan_model.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final WorkoutSummary summary;
  final double screenWidth;
  final double screenHeight;

  const WorkoutSummaryCard({
    super.key,
    required this.summary,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.045),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.025),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
                child: Icon(
                  Icons.summarize_outlined,
                  color: AppColors.primaryGreen,
                  size: screenWidth * 0.06,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Text(
                'Plan Summary',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildInfoRow(
            'Training Days',
            '${summary.gymDaysPerWeek} days/week',
            Icons.calendar_today,
          ),
          SizedBox(height: screenHeight * 0.012),
          _buildInfoRow(
            'Fitness Level',
            _capitalize(summary.fitnessLevel),
            Icons.trending_up,
          ),
          SizedBox(height: screenHeight * 0.012),
          _buildInfoRow(
            'Session Duration',
            summary.sessionDuration,
            Icons.schedule,
          ),
          if (summary.goal != null && summary.goal!.isNotEmpty) ...[
            SizedBox(height: screenHeight * 0.012),
            _buildInfoRow(
              'Goal',
              _formatGoal(summary.goal!),
              Icons.flag,
            ),
          ],
          SizedBox(height: screenHeight * 0.015),
          Divider(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
            height: 1,
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            'Workout Split',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          Text(
            summary.workoutSplit,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryGreen,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textSecondary,
          size: screenWidth * 0.045,
        ),
        SizedBox(width: screenWidth * 0.025),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.036,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.036,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatGoal(String goal) {
    return goal.split('_').map((word) => _capitalize(word)).join(' ');
  }
}
