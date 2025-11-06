import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/controllers/language_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: "Minnie");
  final _emailController = TextEditingController(text: "minnie@gmail.com");
  final _dobController = TextEditingController(text: "28/11/2005");
  String _country = "Mexico";

  // Language Controller
  final LanguageController _langController = Get.find<LanguageController>();

  // Language code mapping

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: l10n.save,
          onTap: () => context.go(RoutePath.myProfile.addBasePath),
        ),
      ),

      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.myProfile.addBasePath),
        ),
        title: Text(
          l10n.editProfile,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xFF1F2937), fontSize: 18, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== Avatar with Edit Icon =====
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Assets.images.av1.image(
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Assets.images.edit.image(
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildTextField(label: l10n.name, controller: _nameController),
            const SizedBox(height: 16),

            _buildTextField(label: l10n.email, controller: _emailController),
            const SizedBox(height: 16),

            _buildTextField(
              label: l10n.dateOfBirth,
              controller: _dobController,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: l10n.country,
              value: _country,
              items: ["Mexico", "USA", "Canada"],
              onChanged: (value) => setState(() => _country = value!),
            ),
            const SizedBox(height: 16),

            _buildLanguageSelection(),
          ],
        ),
      ),
    );
  }

  // ---------- Custom Widgets ----------

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    Icon? suffixIcon,
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
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelection() {
    final l10n = AppLocalizations.of(context)!;

    final languages = [
      {"name": l10n.english, "icon": Assets.images.english, "code": "en"},
      {"name": l10n.french, "icon": Assets.images.french, "code": "fr"},
      {"name": l10n.spanish, "icon": Assets.images.epsol, "code": "es"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.preferredLanguage,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final currentLang = _langController.currentLanguageCode;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: languages.map((lang) {
                final isSelected = currentLang == lang["code"];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Change language using controller
                      _langController.changeLanguage(lang["code"] as String);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSelected ? const Color(0xFFF4A261) : Colors.white,
                      foregroundColor:
                      isSelected ? Colors.white : const Color(0xFF1F2937),
                      side: const BorderSide(color: Color(0xFFF4A261)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        (lang["icon"] as AssetGenImage)
                            .image(width: 20, height: 20),
                        const SizedBox(width: 10),
                        Text(lang["name"] as String),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}