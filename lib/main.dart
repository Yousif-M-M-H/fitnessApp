import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'core/routes/app_router.dart';
import 'core/network/api_constants.dart';

void main() {
  // Print network configuration for debugging
  ApiConstants.printNetworkInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLife',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      // Use named routes
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
