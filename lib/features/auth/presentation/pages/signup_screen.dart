import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authRepository: AuthRepositoryImpl(
          remoteDataSource: AuthRemoteDataSourceImpl(
            dioClient: DioClient(),
          ),
        ),
      ),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primaryGreen,
              onPrimary: AppColors.textDark,
              surface: AppColors.inputBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  String? _validateFields() {
    // Check if all fields are filled
    if (_emailController.text.trim().isEmpty) {
      return 'Please enter your email address';
    }
    if (_passwordController.text.isEmpty) {
      return 'Please enter a password';
    }
    if (_firstNameController.text.trim().isEmpty) {
      return 'Please enter your first name';
    }
    if (_lastNameController.text.trim().isEmpty) {
      return 'Please enter your last name';
    }
    if (_phoneController.text.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    if (_selectedDate == null) {
      return 'Please select your date of birth';
    }

    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      return 'Please enter a valid email address';
    }

    // Password validation (minimum 6 characters as per backend)
    if (_passwordController.text.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // Phone validation (only digits)
    final phoneRegex = RegExp(r'^\d{10,15}$');
    if (!phoneRegex.hasMatch(_phoneController.text.trim())) {
      return 'Please enter a valid phone number (10-15 digits)';
    }

    // Date validation (user must be at least 10 years old and not in future)
    final now = DateTime.now();
    final minDate = DateTime(now.year - 120, now.month, now.day);
    final maxDate = DateTime(now.year - 10, now.month, now.day);

    if (_selectedDate!.isAfter(maxDate)) {
      return 'You must be at least 10 years old to sign up';
    }
    if (_selectedDate!.isBefore(minDate)) {
      return 'Please enter a valid date of birth';
    }

    return null; // All validations passed
  }

  void _handleSignUp(BuildContext context) {
    // Validate all fields
    final errorMessage = _validateFields();

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // All validations passed, proceed with sign up
    context.read<AuthCubit>().signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          dateOfBirth: _selectedDate!,
          phone: _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.03),

                  // Close button
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textPrimary,
                      size: screenWidth * 0.08,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Title
                  Center(
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Email field
                  CustomTextField(
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    screenWidth: screenWidth,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Password field
                  CustomTextField(
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                    screenWidth: screenWidth,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // First Name and Last Name row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(screenWidth * 0.04),
                          ),
                          child: TextField(
                            controller: _firstNameController,
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: screenWidth * 0.04,
                            ),
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.textSecondary,
                                fontSize: screenWidth * 0.04,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.inputBackground,
                            borderRadius: BorderRadius.circular(screenWidth * 0.04),
                          ),
                          child: TextField(
                            controller: _lastNameController,
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: screenWidth * 0.04,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: GoogleFonts.poppins(
                                color: AppColors.textSecondary,
                                fontSize: screenWidth * 0.04,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                                vertical: screenWidth * 0.045,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Phone field
                  CustomTextField(
                    hintText: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    screenWidth: screenWidth,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Date of Birth field
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: 'Date of Birth',
                        icon: Icons.calendar_today_outlined,
                        controller: _dateOfBirthController,
                        screenWidth: screenWidth,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // Create Account Button with BlocConsumer
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Account created successfully! Please sign in.',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: AppColors.primaryGreen,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        // Navigate to login screen
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.login,
                        );
                      } else if (state is AuthError) {
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
                      final isLoading = state is AuthLoading;

                      return SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.068,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _handleSignUp(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: AppColors.textDark,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.04),
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
                                  'Create Account',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.047,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Already have an account
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.login);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
