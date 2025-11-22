import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phoneNumber = '';
  String _dateOfBirth = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService.getUserData();
    setState(() {
      _firstName = userData['firstName'] ?? 'User';
      _lastName = userData['lastName'] ?? '';
      _email = userData['email'] ?? 'Not provided';
      _phoneNumber = userData['phoneNumber'] ?? 'Not provided';
      _dateOfBirth = _formatDate(userData['dateOfBirth'] ?? 'Not provided');
    });
  }

  String _formatDate(String dateString) {
    if (dateString == 'Not provided' || dateString.isEmpty) {
      return 'Not provided';
    }

    try {
      // Handle both ISO timestamps (2000-01-01T00:00:00.000Z) and simple dates (2000-01-01)
      // Extract just the date part before any 'T' character
      final datePart = dateString.split('T')[0];

      // Parse date from format: 2000-01-01
      final parts = datePart.split('-');
      if (parts.length != 3) return dateString;

      final year = parts[0];
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // Month names
      const monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];

      // Format as: January 1, 2000
      return '${monthNames[month - 1]} $day, $year';
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
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
    await AuthService.clearAuthData();

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
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      // Profile Avatar with Initials
                      Container(
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
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
                              fontSize: screenWidth * 0.1,
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
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Personal Details Section
                      Container(
                        width: double.infinity,
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
                            Text(
                              'Personal Details',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.025),

                            // Email
                            _buildDetailRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: _email,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // Phone Number
                            _buildDetailRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone Number',
                              value: _phoneNumber,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // Date of Birth
                            _buildDetailRow(
                              icon: Icons.cake_outlined,
                              label: 'Date of Birth',
                              value: _dateOfBirth,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryGreen,
            size: screenWidth * 0.05,
          ),
        ),
        SizedBox(width: screenWidth * 0.035),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.032,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: screenHeight * 0.003),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
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
