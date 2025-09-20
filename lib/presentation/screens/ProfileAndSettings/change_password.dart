import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: "Update Password",
          onTap: () => context.go(RoutePath.accountSettings.addBasePath),
        ),
      ),

      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.accountSettings.addBasePath),
        ),
        title: const Text(
          "Change Password",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      /// ===== Scrollable Body =====
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: "New Password",
                controller: _newPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Confirm Password",
                controller: _confirmPasswordController,
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
