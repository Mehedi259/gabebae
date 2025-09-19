import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
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
  String _language = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// ===== Fixed Bottom Button =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: CustomButton(
          text: "Save",
          onTap: () => context.go(RoutePath.myProfile.addBasePath),
        ),
      ),

      appBar: AppBar(
        leading: IconButton(
          icon: Assets.images.dibbaback.image(width: 32, height: 44),
          onPressed: () => context.go(RoutePath.myProfile.addBasePath),
        ),
        title: const Text(
          "Edit Profile",
          textAlign: TextAlign.center,
          style: TextStyle(
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
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Assets.images.av1.image(width: 120, height: 120),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(label: "Name", controller: _nameController),
            const SizedBox(height: 16),

            _buildTextField(label: "Email", controller: _emailController),
            const SizedBox(height: 16),

            _buildTextField(
              label: "Date of Birth",
              controller: _dobController,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 16),

            _buildDropdownField(
              label: "Country",
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
          value: value,
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
    final languages = [
      {"name": "English", "icon": Assets.images.english},
      {"name": "Français", "icon": Assets.images.french},
      {"name": "Español", "icon": Assets.images.epsol},
      // আরও চাইলে add করতে পারেন
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preferred Language",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: languages.map((lang) {
              final isSelected = _language == lang["name"];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () => setState(() => _language = lang["name"] as String),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? const Color(0xFFF4A261) : Colors.white,
                    side: const BorderSide(color: Color(0xFFF4A261)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      (lang["icon"] as AssetGenImage).image(width: 20, height: 20),
                      const SizedBox(width: 10),
                      Text(lang["name"] as String),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
