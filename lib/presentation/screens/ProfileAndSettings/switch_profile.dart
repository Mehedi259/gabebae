import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../utils/app_colors/app_colors.dart';

class Profile {
  final String name;
  final String role;
  final String imageUrl;

  Profile({required this.name, required this.role, required this.imageUrl});
}

class SwitchProfileScreen extends StatefulWidget {
  const SwitchProfileScreen({super.key});

  @override
  _SwitchProfileScreenState createState() => _SwitchProfileScreenState();
}

class _SwitchProfileScreenState extends State<SwitchProfileScreen> {
  int activeIndex = 0; // Index of the active profile (Bennie - 0)

  final List<Profile> profiles = [
    Profile(
      name: 'Bennie - You',
      role: 'You',
      imageUrl: 'https://via.placeholder.com/60?text=B', // Replace with actual image
    ),
    Profile(
      name: 'Dad',
      role: 'Family Member',
      imageUrl: 'https://via.placeholder.com/60?text=D',
    ),
    Profile(
      name: 'Dad', // Two identical "Dad" profiles as per screenshot
      role: 'Family Member',
      imageUrl: 'https://via.placeholder.com/60?text=D',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: _buildHeader(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildCurrentProfile(),
            const SizedBox(height: 24),
            _buildOthersProfile(),
            const SizedBox(height: 12),
            _buildAddNewProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      titleSpacing: 16,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Assets.images.dibbaback.image(width: 40, height: 40),
            onPressed: () => context.go(RoutePath.myProfile.addBasePath),
          ),
          Text(
            "👤 Switch Profile",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: const Color(0xFF1F2937),
            ),
          ),
          Container(width: 75), // Placeholder to match layout
        ],
      ),
    );
  }

  Widget _buildCurrentProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Profile',
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                activeIndex = 0;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(profiles[0].imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profiles[0].name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          profiles[0].role,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (activeIndex == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDAA5D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Active Profile',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOthersProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Others Profile',
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profiles.length - 1,
            itemBuilder: (context, index) {
              final profileIndex = index + 1;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeIndex = profileIndex;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(profiles[profileIndex].imageUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profiles[profileIndex].name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              profiles[profileIndex].role,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.more_horiz, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewProfileButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to create profile screen
      },
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.grey),
            const SizedBox(width: 16),
            Text(
              'Add New Profile',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              'Create a profile for family member',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}