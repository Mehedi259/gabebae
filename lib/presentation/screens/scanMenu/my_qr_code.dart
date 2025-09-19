import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

import '../../../core/routes/route_path.dart';

// First Screen: À la carte QR Screen
class AlaCarteQRScreen extends StatelessWidget {
  final String qrData;

  const AlaCarteQRScreen({
    super.key,
    this.qrData = "https://menusidekick.com/dietary-preferences/user123",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),

      /// HEADER
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
                onPressed: () => context.go(RoutePath.askChatBot.addBasePath),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.restaurant, color: Color(0xFF1F2937), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "À la carte",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// QR CODE CONTAINER
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              /// DESCRIPTION TEXT
              Text(
                "Scan this to view my dietary preferences & safe meals.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              /// SHARE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _shareQRCode(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE27B4F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black26,
                  ),
                  child: Text(
                    "Share QR Code",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareQRCode(BuildContext context) {
    Share.share(
      'Check out my dietary preferences and safe meals: $qrData',
      subject: 'My Menu Sidekick QR Code',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "QR Code shared successfully!",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Second Screen: My QR Code Screen
class MyQRCodeScreen extends StatelessWidget {
  final String qrData;

  const MyQRCodeScreen({
    super.key,
    this.qrData = "https://menusidekick.com/dietary-preferences/user123",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),

      /// HEADER
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
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Text(
                "My QR Code",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// QR CODE CONTAINER
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 250.0,
                  backgroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              /// DESCRIPTION TEXT
              Text(
                "Scan this to view my dietary preferences & safe meals.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              /// SHARE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _shareQRCode(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE27B4F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black26,
                  ),
                  child: Text(
                    "Share QR Code",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareQRCode(BuildContext context) {
    // Copy to clipboard option
    Clipboard.setData(ClipboardData(text: qrData)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "QR Code link copied to clipboard!",
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });

    // Also share via system share
    Future.delayed(const Duration(milliseconds: 500), () {
      Share.share(
        'Check out my dietary preferences and safe meals: $qrData',
        subject: 'My Menu Sidekick QR Code',
      );
    });
  }
}

// Navigation helper functions
class QRCodeNavigation {
  static void toAlaCarteQR(BuildContext context, {String? qrData}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlaCarteQRScreen(
          qrData: qrData ?? "https://menusidekick.com/alacarte/user123",
        ),
      ),
    );
  }

  static void toMyQRCode(BuildContext context, {String? qrData}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyQRCodeScreen(
          qrData: qrData ?? "https://menusidekick.com/profile/user123",
        ),
      ),
    );
  }
}

// Example usage in your existing buttons:
/*
// For À la carte button:
ElevatedButton(
  onPressed: () => QRCodeNavigation.toAlaCarteQR(context),
  child: Text("À La Carte Mode"),
)

// For My QR Code button:
ElevatedButton(
  onPressed: () => QRCodeNavigation.toMyQRCode(context),
  child: Text("My QR Code"),
)
*/