import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class TotalWorkoutsChart extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const TotalWorkoutsChart({
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
                    '19',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    '+15%',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
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

  WaveChartPainter({
    required this.color,
    required this.screenWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    path.moveTo(0, size.height * 0.7);
    
    path.quadraticBezierTo(
      size.width * 0.125, size.height * 0.3,
      size.width * 0.25, size.height * 0.5,
    );
    
    path.quadraticBezierTo(
      size.width * 0.375, size.height * 0.7,
      size.width * 0.5, size.height * 0.6,
    );
    
    path.quadraticBezierTo(
      size.width * 0.625, size.height * 0.5,
      size.width * 0.75, size.height * 0.2,
    );
    
    path.quadraticBezierTo(
      size.width * 0.875, size.height * 0.0,
      size.width, size.height * 0.4,
    );

    canvas.drawPath(path, paint);

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}