import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/nutrition_remote_datasource.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../cubit/nutrition_cubit.dart';
import '../widgets/nutrition_input_field.dart';
import '../widgets/gender_selector.dart';
import '../widgets/activity_level_selector.dart';
import '../widgets/goal_selector.dart';

class NutritionInputScreen extends StatelessWidget {
  const NutritionInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NutritionCubit(
        nutritionRepository: NutritionRepositoryImpl(
          remoteDataSource: NutritionRemoteDataSourceImpl(
            dioClient: DioClient(),
          ),
        ),
      ),
      child: const NutritionInputView(),
    );
  }
}

class NutritionInputView extends StatefulWidget {
  const NutritionInputView({super.key});

  @override
  State<NutritionInputView> createState() => _NutritionInputViewState();
}

class _NutritionInputViewState extends State<NutritionInputView>
    with SingleTickerProviderStateMixin {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedActivityLevel = 'moderate';
  String _selectedGoal = 'maintain_weight';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _ageController.clear();
      _selectedGender = 'Male';
      _selectedActivityLevel = 'moderate';
      _selectedGoal = 'maintain_weight';
    });
  }

  Future<void> _handleCalculate(BuildContext context) async {
    if (_weightController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all fields',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Get token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Session expired. Please login again.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    context.read<NutritionCubit>().calculateNutrition(
      weight: double.parse(_weightController.text),
      height: double.parse(_heightController.text),
      age: int.parse(_ageController.text),
      gender: _selectedGender,
      activityLevel: _selectedActivityLevel,
      goal: _selectedGoal,
      token: token,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkGreenBackground,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _resetForm();
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textPrimary,
                        size: screenWidth * 0.06,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      'Nutrition Calculator',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          Text(
                            'Enter your details to calculate your daily nutritional needs',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.038,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          NutritionInputField(
                            controller: _weightController,
                            label: 'Weight',
                            hint: 'Enter your weight',
                            icon: Icons.monitor_weight_outlined,
                            suffix: 'kg',
                            keyboardType: TextInputType.number,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          NutritionInputField(
                            controller: _heightController,
                            label: 'Height',
                            hint: 'Enter your height',
                            icon: Icons.height_outlined,
                            suffix: 'cm',
                            keyboardType: TextInputType.number,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          NutritionInputField(
                            controller: _ageController,
                            label: 'Age',
                            hint: 'Enter your age',
                            icon: Icons.cake_outlined,
                            suffix: 'years',
                            keyboardType: TextInputType.number,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          GenderSelector(
                            selectedGender: _selectedGender,
                            onGenderChanged: (gender) {
                              setState(() {
                                _selectedGender = gender;
                              });
                            },
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          ActivityLevelSelector(
                            selectedLevel: _selectedActivityLevel,
                            onLevelChanged: (level) {
                              setState(() {
                                _selectedActivityLevel = level;
                              });
                            },
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          GoalSelector(
                            selectedGoal: _selectedGoal,
                            onGoalChanged: (goal) {
                              setState(() {
                                _selectedGoal = goal;
                              });
                            },
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          SizedBox(height: screenHeight * 0.05),

                          BlocConsumer<NutritionCubit, NutritionState>(
                            listener: (context, state) {
                              if (state is NutritionSuccess) {
                                // Navigate to results and reset form when coming back
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.nutritionResults,
                                  arguments: state.data,
                                ).then((_) {
                                  // Reset form when user comes back from results screen
                                  _resetForm();
                                  // Reset cubit state
                                  context.read<NutritionCubit>().resetState();
                                });
                              } else if (state is NutritionError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      state.message,
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is NutritionLoading;

                              return SizedBox(
                                width: double.infinity,
                                height: screenHeight * 0.065,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _handleCalculate(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                    foregroundColor: AppColors.textDark,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.04,
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          height: screenWidth * 0.05,
                                          width: screenWidth * 0.05,
                                          child: CircularProgressIndicator(
                                            color: AppColors.textDark,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Calculate My Nutrition',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
