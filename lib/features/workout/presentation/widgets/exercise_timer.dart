import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ExerciseTimer extends StatefulWidget {
  final int initialSeconds;
  final double screenWidth;

  const ExerciseTimer({
    super.key,
    required this.initialSeconds,
    required this.screenWidth,
  });

  @override
  State<ExerciseTimer> createState() => _ExerciseTimerState();
}

class _ExerciseTimerState extends State<ExerciseTimer> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _pauseTimer();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.initialSeconds;
      _isRunning = false;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.initialSeconds;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timer display
        Text(
          _formatTime(_remainingSeconds),
          style: GoogleFonts.poppins(
            fontSize: widget.screenWidth * 0.15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: widget.screenWidth * 0.05),
        // Timer controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reset button
            Container(
              width: widget.screenWidth * 0.15,
              height: widget.screenWidth * 0.15,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.inputBorder.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: _resetTimer,
                icon: Icon(
                  Icons.refresh,
                  color: AppColors.textSecondary,
                  size: widget.screenWidth * 0.06,
                ),
              ),
            ),
            SizedBox(width: widget.screenWidth * 0.05),
            // Play/Pause button
            Container(
              width: widget.screenWidth * 0.2,
              height: widget.screenWidth * 0.2,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _toggleTimer,
                icon: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  color: AppColors.textDark,
                  size: widget.screenWidth * 0.1,
                ),
              ),
            ),
            SizedBox(width: widget.screenWidth * 0.05),
            // Stop button
            Container(
              width: widget.screenWidth * 0.15,
              height: widget.screenWidth * 0.15,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.inputBorder.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: _stopTimer,
                icon: Icon(
                  Icons.stop,
                  color: AppColors.textSecondary,
                  size: widget.screenWidth * 0.06,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
