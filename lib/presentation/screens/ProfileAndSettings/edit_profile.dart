// lib/presentation/screens/ProfileAndSettings/edit_profile.dart

import 'dart:io';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../core/controllers/language_controller.dart';
import '../../../core/controllers/profile_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../widgets/custom_bottons/custom_button/button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();
  final LanguageController _langController = Get.find<LanguageController>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  String _country = "Mexico";

  // Image handling
  File? _selectedImageFile;
  Uint8List? _selectedWebImage;
  String? _currentAvatarUrl;
  bool _hasNewImage = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current profile data
    final activeProfile = _profileController.activeProfile.value;

    _nameController = TextEditingController(
        text: activeProfile?.profileName ?? "User"
    );
    _country = _profileController.country.value;
    _currentAvatarUrl = activeProfile?.avatar;

    // Load data if not already loaded
    if (activeProfile == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _profileController.fetchActiveProfile();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // Web platform
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedWebImage = bytes;
            _hasNewImage = true;
          });
        } else {
          // Mobile/Desktop platform
          setState(() {
            _selectedImageFile = File(pickedFile.path);
            _hasNewImage = true;
          });
        }

        if (kDebugMode) {
          print('✅ Image selected successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error picking image: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  /// Show image source selection dialog
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            if (_hasNewImage || _currentAvatarUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Picture',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Take photo from camera
  Future<void> _takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedWebImage = bytes;
            _hasNewImage = true;
          });
        } else {
          setState(() {
            _selectedImageFile = File(pickedFile.path);
            _hasNewImage = true;
          });
        }

        if (kDebugMode) {
          print('✅ Photo taken successfully');
        }
      }
    } catch (e) {
      print('❌ Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to take photo: $e')),
        );
      }
    }
  }

  /// Remove selected image
  void _removeImage() {
    setState(() {
      _selectedImageFile = null;
      _selectedWebImage = null;
      _currentAvatarUrl = null;
      _hasNewImage = true; // Mark as changed to update API
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Obx(() => CustomButton(
          text: _profileController.isLoading.value ? 'Saving...' : l10n.save,
          onTap: _profileController.isLoading.value
              ? () {}
              : () => _saveProfile(),
        )),
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
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        final activeProfile = _profileController.activeProfile.value;

        if (activeProfile == null) {
          return const Center(child: Text('No active profile'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Avatar with Edit Icon
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _getImageProvider(),
                      child: _getImageProvider() == null
                          ? ClipOval(
                        child: Assets.images.av1.image(
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4A261),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Tap to change picture',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildTextField(label: l10n.name, controller: _nameController),

              const SizedBox(height: 16),

              _buildDropdownField(
                label: l10n.country,
                value: _country,
                items: ["Mexico", "USA", "Canada", "Bangladesh"],
                onChanged: (value) => setState(() => _country = value!),
              ),
              const SizedBox(height: 16),

              _buildLanguageSelection(),
            ],
          ),
        );
      }),
    );
  }

  /// Get image provider for avatar display
  ImageProvider? _getImageProvider() {
    if (_selectedWebImage != null) {
      return MemoryImage(_selectedWebImage!);
    } else if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    } else if (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty) {
      return NetworkImage(_currentAvatarUrl!);
    }
    return null;
  }

  /// Save profile changes
  Future<void> _saveProfile() async {
    final activeProfile = _profileController.activeProfile.value;

    if (activeProfile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active profile found')),
      );
      return;
    }

    // Convert language code to full name for API
    final currentLangCode = _langController.currentLanguageCode;
    String languageFullName;

    switch (currentLangCode) {
      case 'en':
        languageFullName = 'English';
        break;
      case 'fr':
        languageFullName = 'French';
        break;
      case 'es':
        languageFullName = 'Spanish';
        break;
      default:
        languageFullName = 'English';
    }

    if (kDebugMode) {
      print('🔤 Language conversion: $currentLangCode -> $languageFullName');
    }

    bool success;

    // Check if there's a new image to upload
    if (_hasNewImage && (_selectedImageFile != null || _selectedWebImage != null)) {
      // Upload with new image
      success = await _profileController.updateProfileWithImage(
        profileId: activeProfile.id,
        profileName: _nameController.text.trim(),
        profileImage: _selectedImageFile,
        webProfileImage: _selectedWebImage,
        newCountry: _country,
        newLanguage: languageFullName,
      );
    } else {
      // Update without image
      success = await _profileController.updateProfile(
        profileId: activeProfile.id,
        profileName: _nameController.text.trim(),
        avatar: _currentAvatarUrl,
        newCountry: _country,
        newLanguage: languageFullName,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      context.go(RoutePath.myProfile.addBasePath);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_profileController.errorMessage.value.isEmpty
              ? 'Failed to update profile'
              : _profileController.errorMessage.value),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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