// lib/presentation/screens/scanMenu/scan_result_save_your_meal.dart (UPDATED)

import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../../core/controllers/create_plate_controller.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';

class SaveMealScreen extends StatefulWidget {
  const SaveMealScreen({super.key});

  @override
  State<SaveMealScreen> createState() => _SaveMealScreenState();
}

class _SaveMealScreenState extends State<SaveMealScreen> {
  final TextEditingController _mealNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late CreatePlateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CreatePlateController>();
  }

  List<String> getPlateCombo(AppLocalizations l10n) {
    // Get from controller
    return _controller.selectedIngredients.isNotEmpty
        ? _controller.selectedIngredients
        : [l10n.extraVeggies, l10n.spicy, l10n.spicy];
  }

  Future<void> _pickImage(AppLocalizations l10n) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(l10n.takePhoto),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    if (kIsWeb) {
                      final bytes = await image.readAsBytes();
                      _controller.setMealImageBytes(bytes);
                    } else {
                      _controller.setMealImage(File(image.path));
                    }
                    setState(() {});
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.chooseFromGallery),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    if (kIsWeb) {
                      final bytes = await image.readAsBytes();
                      _controller.setMealImageBytes(bytes);
                    } else {
                      _controller.setMealImage(File(image.path));
                    }
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveMeal() async {
    if (_mealNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a meal name',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_controller.selectedIngredients.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one ingredient',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await _controller.saveMyPlate(
      mealName: _mealNameController.text.trim(),
      plateCombo: _controller.selectedIngredients,
      imageFile: _controller.currentMealImage,
      imageBytes: _controller.currentMealImageBytes,
    );

    if (success && mounted) {
      context.go(RoutePath.home.addBasePath);
    }
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plateCombo = getPlateCombo(l10n);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 1,
          titleSpacing: 16,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () =>
                    context.go(RoutePath.scanResultOrderingTips.addBasePath),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.saveYourMeal,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// PLATE COMBO SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF10B981), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourPlateCombo,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: const Color(0xFF1F2937),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: plateCombo.map((ingredient) {
                        Color bgColor = const Color(0xFFDCFCE7);
                        Color textColor = const Color(0xFF059669);

                        if (ingredient.contains("🌶️")) {
                          bgColor = const Color(0xFFFEF3C7);
                          textColor = const Color(0xFFD97706);
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: textColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ingredient,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.close, size: 16, color: textColor),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// PHOTO SECTION
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: _controller.currentMealImage != null ||
                    _controller.currentMealImageBytes != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: kIsWeb && _controller.currentMealImageBytes != null
                      ? Image.memory(
                    _controller.currentMealImageBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                      : Image.file(
                    _controller.currentMealImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
                    : GestureDetector(
                  onTap: () => _pickImage(l10n),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.tapToAddPhoto,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_controller.currentMealImage != null ||
                  _controller.currentMealImageBytes != null) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _pickImage(l10n),
                    icon: const Icon(Icons.edit, size: 18),
                    label: Text(
                      l10n.changePhoto,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF3B82F6),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              /// MEAL NAME
              Text(
                l10n.giveYourMealName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 16),

              /// TEXT INPUT
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                ),
                child: TextField(
                  controller: _mealNameController,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.mealNamePlaceholder,
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFFD1D5DB),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _controller.setMealName(value);
                    setState(() {});
                  },
                ),
              ),

              const SizedBox(height: 12),
              Text(
                l10n.thisWillAppear,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),

      /// SAVE BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: Colors.white,
        child: Obx(() => ElevatedButton(
          onPressed: _mealNameController.text.trim().isEmpty ||
              _controller.isSavingMeal.value
              ? null
              : _saveMeal,
          style: ElevatedButton.styleFrom(
            backgroundColor: _mealNameController.text.trim().isEmpty
                ? const Color(0xFFD1D5DB)
                : const Color(0xFFE27B4F),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            elevation: _mealNameController.text.trim().isEmpty ? 0 : 6,
            shadowColor: Colors.black26,
          ),
          child: _controller.isSavingMeal.value
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Text(
            l10n.save,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        )),
      ),
    );
  }
}