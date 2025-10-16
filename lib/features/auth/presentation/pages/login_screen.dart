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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn(BuildContext context) {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter email and password',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthCubit>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkGreenBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Log In title at top
                  Text(
                    'Log In',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.15),

                  // Welcome Back
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  // Subtitle
                  Text(
                    'Sign in to continue your fitness journey',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // Email field
                  CustomTextField(
                    hintText: 'Email address',
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

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigate to forgot password
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.038,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Log In Button with BlocConsumer
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.featureSelection,
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
                              : () => _handleSignIn(context),
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
                                  'Log In',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.047,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // New User? Sign Up button with border
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.068,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.signUp);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.textSecondary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'New User? Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.047,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
