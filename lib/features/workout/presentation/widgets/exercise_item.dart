import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/exercise_model.dart';
import 'exercise_timer.dart';

class ExerciseItem extends StatefulWidget {
  final ExerciseModel exercise;
  final double screenWidth;
  final double screenHeight;

  const ExerciseItem({
    super.key,
    required this.exercise,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<ExerciseItem> createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  bool _isExpanded = false;

  IconData _getExerciseIcon() {
    final name = widget.exercise.name.toLowerCase();
    if (name.contains('squat')) return Icons.fitness_center;
    if (name.contains('push') || name.contains('press')) return Icons.sports_gymnastics;
    if (name.contains('plank') || name.contains('core')) return Icons.self_improvement;
    if (name.contains('curl')) return Icons.sports_martial_arts;
    if (name.contains('pull')) return Icons.accessibility_new;
    if (name.contains('run') || name.contains('cardio')) return Icons.directions_run;
    if (name.contains('lunge')) return Icons.directions_walk;
    return Icons.fitness_center;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.screenHeight * 0.015),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(widget.screenWidth * 0.03),
        border: Border.all(
          color: AppColors.inputBorder.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(widget.screenWidth * 0.03),
            child: Padding(
              padding: EdgeInsets.all(widget.screenWidth * 0.04),
              child: Row(
                children: [
                  // Exercise icon
                  Container(
                    width: widget.screenWidth * 0.12,
                    height: widget.screenWidth * 0.12,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(widget.screenWidth * 0.02),
                    ),
                    child: Icon(
                      _getExerciseIcon(),
                      color: AppColors.primaryGreen,
                      size: widget.screenWidth * 0.06,
                    ),
                  ),
                  SizedBox(width: widget.screenWidth * 0.035),
                  // Exercise info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.exercise.name,
                          style: GoogleFonts.poppins(
                            fontSize: widget.screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: widget.screenHeight * 0.004),
                        Text(
                          '${widget.exercise.displaySets} sets x ${widget.exercise.displayReps}',
                          style: GoogleFonts.poppins(
                            fontSize: widget.screenWidth * 0.035,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand/collapse icon
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: widget.screenWidth * 0.06,
                  ),
                ],
              ),
            ),
          ),
          // Expanded content - show description
          if (_isExpanded)
            Container(
              padding: EdgeInsets.fromLTRB(
                widget.screenWidth * 0.04,
                widget.screenHeight * 0.01,
                widget.screenWidth * 0.04,
                widget.screenWidth * 0.04,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.inputBorder.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: widget.screenHeight * 0.015),
                  // Description title
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryGreen,
                        size: widget.screenWidth * 0.045,
                      ),
                      SizedBox(width: widget.screenWidth * 0.02),
                      Text(
                        'How to perform:',
                        style: GoogleFonts.poppins(
                          fontSize: widget.screenWidth * 0.038,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.screenHeight * 0.012),
                  // Description text
                  Text(
                    widget.exercise.description.isNotEmpty
                        ? widget.exercise.description
                        : 'Perform this exercise with proper form and controlled movements.',
                    style: GoogleFonts.poppins(
                      fontSize: widget.screenWidth * 0.036,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  // Show timer for time-based exercises
                  if (widget.exercise.isTimeBased && widget.exercise.timeInSeconds != null) ...[
                    SizedBox(height: widget.screenHeight * 0.02),
                    ExerciseTimer(
                      initialSeconds: widget.exercise.timeInSeconds!,
                      screenWidth: widget.screenWidth,
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
