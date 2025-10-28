import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../../core/theme/app_colors.dart';

class DailyProgressCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const DailyProgressCard({
    super.key,
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
            'Daily Progress',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              // Circular Progress Indicator
              SizedBox(
                width: screenWidth * 0.18,
                height: screenWidth * 0.18,
                child: CustomPaint(
                  painter: CircularProgressPainter(
                    progress: 0.75,
                    progressColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.inputBorder.withValues(alpha: 0.3),
                    strokeWidth: screenWidth * 0.02,
                  ),
                  child: Center(
                    child: Text(
                      '75%',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workouts Completed',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.042,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '3 of 4 workouts',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}