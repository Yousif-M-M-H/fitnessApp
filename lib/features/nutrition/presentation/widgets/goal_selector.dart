import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class GoalSelector extends StatelessWidget {
  final String selectedGoal;
  final Function(String) onGoalChanged;
  final double screenWidth;
  final double screenHeight;

  const GoalSelector({
    super.key,
    required this.selectedGoal,
    required this.onGoalChanged,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final goals = [
      {
        'value': 'lose_weight',
        'label': 'Lose\nWeight',
        'icon': Icons.trending_down_rounded,
      },
      {
        'value': 'maintain_weight',
        'label': 'Maintain\nWeight',
        'icon': Icons.straighten_rounded,
      },
      {
        'value': 'gain_muscle',
        'label': 'Gain\nMuscle',
        'icon': Icons.trending_up_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitness Goal',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        Row(
          children: [
            ...goals.asMap().entries.map((entry) {
              final index = entry.key;
              final goal = entry.value;
              final isSelected = selectedGoal == goal['value'];

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < goals.length - 1 ? screenWidth * 0.025 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => onGoalChanged(goal['value'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: screenHeight * 0.13,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.13,
                            height: screenWidth * 0.13,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryGreen.withValues(
                                      alpha: 0.2,
                                    )
                                  : AppColors.inputBorder.withValues(
                                      alpha: 0.1,
                                    ),
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.03,
                              ),
                            ),
                            child: Icon(
                              goal['icon'] as IconData,
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.textSecondary,
                              size: screenWidth * 0.07,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            goal['label'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.032,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryGreen
                                  : AppColors.textSecondary,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
