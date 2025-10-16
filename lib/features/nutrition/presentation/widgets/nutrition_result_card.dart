import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class NutritionResultCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final String subtitle;
  final Color color;
  final double screenWidth;
  final double screenHeight;
  final int delay;

  const NutritionResultCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.subtitle,
    required this.color,
    required this.screenWidth,
    required this.screenHeight,
    this.delay = 0,
  });

  @override
  State<NutritionResultCard> createState() => _NutritionResultCardState();
}

class _NutritionResultCardState extends State<NutritionResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Delay animation based on the delay parameter
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.all(widget.screenWidth * 0.045),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(widget.screenWidth * 0.045),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(widget.screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(widget.screenWidth * 0.035),
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: widget.screenWidth * 0.08,
                ),
              ),

              SizedBox(width: widget.screenWidth * 0.04),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.poppins(
                        fontSize: widget.screenWidth * 0.038,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: widget.screenHeight * 0.005),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.value,
                          style: GoogleFonts.poppins(
                            fontSize: widget.screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(width: widget.screenWidth * 0.015),
                        Padding(
                          padding: EdgeInsets.only(bottom: widget.screenHeight * 0.008),
                          child: Text(
                            widget.unit,
                            style: GoogleFonts.poppins(
                              fontSize: widget.screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                              color: widget.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: widget.screenHeight * 0.003),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: widget.screenWidth * 0.032,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Decorative Element
              Container(
                width: widget.screenWidth * 0.01,
                height: widget.screenHeight * 0.06,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(widget.screenWidth * 0.01),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
