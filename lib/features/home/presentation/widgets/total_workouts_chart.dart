import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class TotalWorkoutsChart extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final List<int> weeklyData; // Last 4 weeks of workout counts

  const TotalWorkoutsChart({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total workouts
    final totalWorkouts = weeklyData.fold(0, (sum, count) => sum + count);

    // Calculate percentage change (compare last week to previous week)
    String percentageChange = '+0%';
    if (weeklyData.length >= 2) {
      final lastWeek = weeklyData.last;
      final previousWeek = weeklyData[weeklyData.length - 2];
      if (previousWeek > 0) {
        final change = ((lastWeek - previousWeek) / previousWeek * 100).round();
        percentageChange = change >= 0 ? '+$change%' : '$change%';
      } else if (lastWeek > 0) {
        percentageChange = '+100%';
      }
    }

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
                'Total Workouts',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$totalWorkouts',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    percentageChange,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: percentageChange.startsWith('-')
                          ? Colors.red
                          : AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          SizedBox(
            height: screenHeight * 0.15,
            child: CustomPaint(
              size: Size(double.infinity, screenHeight * 0.15),
              painter: WaveChartPainter(
                color: AppColors.primaryGreen,
                screenWidth: screenWidth,
                data: weeklyData,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildWeekLabel('Week 1'),
              _buildWeekLabel('Week 2'),
              _buildWeekLabel('Week 3'),
              _buildWeekLabel('Week 4'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: screenWidth * 0.03,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class WaveChartPainter extends CustomPainter {
  final Color color;
  final double screenWidth;
  final List<int> data;

  WaveChartPainter({
    required this.color,
    required this.screenWidth,
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Find max value for scaling
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = 0;
    final range = maxValue - minValue;

    // Convert data to points
    final List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      // Invert Y so higher values are at top
      final y = range > 0
          ? size.height - ((data[i] - minValue) / range * size.height * 0.8) - size.height * 0.1
          : size.height * 0.5;
      points.add(Offset(x, y));
    }

    if (points.isEmpty) return;

    // Draw smooth curve through points
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      // Use quadratic bezier for smooth curves
      final controlX = (p0.dx + p1.dx) / 2;
      path.quadraticBezierTo(controlX, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(controlX, p1.dy, p1.dx, p1.dy);
    }

    canvas.drawPath(path, paint);

    // Draw glow effect
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, glowPaint);

    // Draw dots at data points
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
