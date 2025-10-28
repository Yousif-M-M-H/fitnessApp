import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/pages/welcome_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/feature_selection/presentation/pages/feature_selection_screen.dart';
import '../../features/nutrition/presentation/pages/nutrition_input_screen.dart';
import '../../features/nutrition/presentation/pages/nutrition_results_screen.dart';
import '../../features/workout/presentation/pages/workout_preferences_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import 'app_routes.dart';
import '../../features/account/presentation/pages/account_screen.dart';
import '../../features/workout/data/models/workout_plan_model.dart';

/// Centralized route configuration for the application
class AppRouter {
  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case AppRoutes.signUp:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );

      case AppRoutes.featureSelection:
        return MaterialPageRoute(
          builder: (_) => const FeatureSelectionScreen(),
          settings: settings,
        );

      case AppRoutes.nutritionInput:
        return MaterialPageRoute(
          builder: (_) => const NutritionInputScreen(),
          settings: settings,
        );

      case AppRoutes.nutritionResults:
        return MaterialPageRoute(
          builder: (_) => const NutritionResultsScreen(),
          settings: settings,
        );

      case AppRoutes.workoutPreferences:
        return MaterialPageRoute(
          builder: (_) => const WorkoutPreferencesScreen(),
          settings: settings,
        );

      case AppRoutes.home:
        final workoutPlan = settings.arguments as WorkoutPlanModel?;
        return MaterialPageRoute(
          builder: (_) => HomeScreen(workoutPlan: workoutPlan),
          settings: settings,
        );
        case AppRoutes.account:
  return MaterialPageRoute(
    builder: (_) => const AccountScreen(),
    settings: settings,
  );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Initial route
  static const String initialRoute = AppRoutes.welcome;
}