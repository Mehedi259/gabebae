import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/routes/route_path.dart';

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
      backgroundColor: const Color(0xFFF9F5F0),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => context.go(RoutePath.myProfile.addBasePath),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage("https://via.placeholder.com/150"),
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
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4A261),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
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
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preferred Language",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // English Button
            ElevatedButton(
              onPressed: () => setState(() => _language = "English"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _language == "English"
                    ? const Color(0xFFF4A261)
                    : Colors.white,
                side: const BorderSide(color: Color(0xFFF4A261)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Image.asset("assets/flags/uk.png", width: 20),
                  const SizedBox(width: 4),
                  const Text("English"),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // French Button
            ElevatedButton(
              onPressed: () => setState(() => _language = "Français"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _language == "Français"
                    ? const Color(0xFFF4A261)
                    : Colors.white,
                side: const BorderSide(color: Color(0xFFF4A261)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Image.asset("assets/flags/france.png", width: 20),
                  const SizedBox(width: 4),
                  const Text("Français"),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Spanish Button
            ElevatedButton(
              onPressed: () => setState(() => _language = "Español"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _language == "Español"
                    ? const Color(0xFFF4A261)
                    : Colors.white,
                side: const BorderSide(color: Color(0xFFF4A261)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Image.asset("assets/flags/spain.png", width: 20),
                  const SizedBox(width: 4),
                  const Text("Español"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
