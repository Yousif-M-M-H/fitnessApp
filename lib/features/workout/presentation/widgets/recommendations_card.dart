import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/workout_plan_model.dart';

class RecommendationsCard extends StatelessWidget {
  final WorkoutRecommendations recommendations;
  final List<String> generalTips;
  final double screenWidth;
  final double screenHeight;

  const RecommendationsCard({
    super.key,
    required this.recommendations,
    required this.generalTips,
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
          color: AppColors.inputBorder.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cardio Section
          _buildSection(
            icon: Icons.directions_run,
            title: 'Cardio',
            content: recommendations.cardio,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Rest Days Section
          _buildSection(
            icon: Icons.hotel,
            title: 'Rest Days',
            content: recommendations.restDays,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Nutrition Section
          _buildListSection(
            icon: Icons.restaurant_menu,
            title: 'Nutrition',
            items: recommendations.nutrition,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Progression Section
          _buildSection(
            icon: Icons.trending_up,
            title: 'Progression',
            content: recommendations.progression,
          ),

          if (generalTips.isNotEmpty) ...[
            SizedBox(height: screenHeight * 0.02),
            Divider(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              height: 1,
            ),
            SizedBox(height: screenHeight * 0.02),

            // General Tips Section
            _buildListSection(
              icon: Icons.lightbulb_outline,
              title: 'General Tips',
              items: generalTips,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: screenWidth * 0.05,
            ),
            SizedBox(width: screenWidth * 0.025),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.075),
          child: Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.036,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListSection({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: screenWidth * 0.05,
            ),
            SizedBox(width: screenWidth * 0.025),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        ...items.map((item) {
          return Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.075,
              bottom: screenHeight * 0.008,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.006),
                  width: screenWidth * 0.015,
                  height: screenWidth * 0.015,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: screenWidth * 0.025),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.036,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
