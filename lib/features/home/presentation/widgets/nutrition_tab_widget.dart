import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/auth_service.dart';
import '../../../nutrition/presentation/pages/nutrition_input_screen.dart';
import '../../../nutrition/data/models/nutrition_response_model.dart';
import '../../../nutrition/presentation/pages/nutrition_results_screen.dart';

/// Smart nutrition widget that shows calculator or results based on user data
class NutritionTabWidget extends StatefulWidget {
  const NutritionTabWidget({super.key});

  @override
  State<NutritionTabWidget> createState() => _NutritionTabWidgetState();
}

class _NutritionTabWidgetState extends State<NutritionTabWidget> {
  bool _hasNutritionPlan = false;
  NutritionData? _nutritionData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkNutritionData();
  }

  Future<void> _checkNutritionData() async {
    // Check if user has nutrition data
    final hasData = await AuthService.hasNutritionPlan();

    if (hasData) {
      // Load nutrition data from storage
      final data = await AuthService.getNutritionData();

      if (mounted) {
        setState(() {
          _hasNutritionPlan = true;
          _nutritionData = NutritionData(
            dailyCalories: data['dailyCalories'] ?? 0,
            proteinIntake: data['proteinIntake'] ?? 0,
            carbIntake: data['carbIntake'] ?? 0,
            fatIntake: data['fatIntake'] ?? 0,
            bmr: 0, // Not stored, can be recalculated if needed
            tdee: data['dailyCalories'] ?? 0,
          );
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _hasNutritionPlan = false;
          _isLoading = false;
        });
      }
    }
  }

  void _handleRecalculate() async {
    // Clear nutrition data from storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_nutrition_plan', false);
    await prefs.remove('daily_calories');
    await prefs.remove('protein_intake');
    await prefs.remove('carb_intake');
    await prefs.remove('fat_intake');

    // Reset state to show input screen
    if (mounted) {
      setState(() {
        _hasNutritionPlan = false;
        _nutritionData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasNutritionPlan && _nutritionData != null) {
      // Show nutrition results without back button (shown as tab)
      return NutritionResultsScreen(
        nutritionData: _nutritionData!,
        showBackButton: false,
        onRecalculate: _handleRecalculate,
      );
    } else {
      // Show nutrition calculator without back button (shown as tab)
      return NutritionInputScreen(
        showBackButton: false,
        onSuccess: _checkNutritionData,
      );
    }
  }
}
