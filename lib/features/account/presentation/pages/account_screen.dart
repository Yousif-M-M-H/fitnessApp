import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('user_first_name') ?? 'User';
      _lastName = prefs.getString('user_last_name') ?? '';
      _email = prefs.getString('user_email') ?? '';
    });
  }

  String _getInitials() {
    String initials = '';
    if (_firstName.isNotEmpty) {
      initials += _firstName[0].toUpperCase();
    }
    if (_lastName.isNotEmpty) {
      initials += _lastName[0].toUpperCase();
    }
    return initials.isEmpty ? 'U' : initials;
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.welcome,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.darkGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
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
                      'Account',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  children: [
                    // Profile Avatar with Initials
                    Container(
                      width: screenWidth * 0.35,
                      height: screenWidth * 0.35,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getInitials(),
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // User Name
                    Text(
                      '$_firstName $_lastName',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Premium Badge & Join Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.008,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.05,
                            ),
                          ),
                          child: Text(
                            'Premium Member',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.032,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          'Joined 2024',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Menu Sections
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MANAGE Section
                      Text(
                        'MANAGE',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Personal Details',
                        onTap: () {
                          // TODO: Navigate to personal details
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),

                      SizedBox(height: screenHeight * 0.012),

                      _buildMenuItem(
                        icon: Icons.tune_outlined,
                        title: 'Preferences',
                        onTap: () {
                          // TODO: Navigate to preferences
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),

                      SizedBox(height: screenHeight * 0.012),

                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          // TODO: Navigate to settings
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // HISTORY Section
                      Text(
                        'HISTORY',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      _buildMenuItem(
                        icon: Icons.fitness_center_outlined,
                        title: 'Workout History',
                        onTap: () {
                          // TODO: Navigate to workout history
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),

                      SizedBox(height: screenHeight * 0.012),

                      _buildMenuItem(
                        icon: Icons.flag_outlined,
                        title: 'Goal History',
                        onTap: () {
                          // TODO: Navigate to goal history
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.065,
                        child: ElevatedButton(
                          onPressed: () {
                            _showLogoutDialog(context, screenWidth, screenHeight);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withValues(alpha: 0.15),
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.04,
                              ),
                              side: BorderSide(
                                color: Colors.red.withValues(alpha: 0.5),
                                width: 1.5,
                              ),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                size: screenWidth * 0.05,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                'Logout',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.042,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.045,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          border: Border.all(
            color: AppColors.inputBorder.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(screenWidth * 0.02),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGreen,
                size: screenWidth * 0.055,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSecondary,
              size: screenWidth * 0.045,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.inputBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.038,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.038,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}