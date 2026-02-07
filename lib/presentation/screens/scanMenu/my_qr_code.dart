import 'package:MenuSideKick/core/routes/route_path.dart';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';


import '../../../l10n/app_localizations.dart';
import '../../../utils/app_colors/app_colors.dart';
 import '../../../core/services/user_service.dart';
import '../../../utils/storage/storage_helper.dart';

/// =======================================
/// À la carte QR Screen
/// =======================================
class AlaCarteQRScreen extends StatefulWidget {
  final String? qrData;

  const AlaCarteQRScreen({
    super.key,
    this.qrData,
  });

  @override
  State<AlaCarteQRScreen> createState() => _AlaCarteQRScreenState();
}

class _AlaCarteQRScreenState extends State<AlaCarteQRScreen> {
  String? _qrData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQRData();
  }

  Future<void> _loadQRData() async {
    try {
      if (widget.qrData != null) {
        setState(() {
          _qrData = widget.qrData;
          _isLoading = false;
        });
        return;
      }

      print('🔍 AlaCarteQR: Fetching active profile...');
      
      // Try to get active profile
      try {
        final activeProfile = await UserService.getActiveProfile();
        print('✅ AlaCarteQR: Active profile received: $activeProfile');
        
        final userId = activeProfile['userId'];
        final profileName = activeProfile['profileName'];
        
        print('✅ AlaCarteQR: userId=$userId, profileName=$profileName');
        
        setState(() {
          _qrData = 'https://api.menusidekick.app/api/dining-profile/$userId/$profileName/';
          _isLoading = false;
        });
        
        print('✅ AlaCarteQR: QR Data set to: $_qrData');
      } catch (profileError) {
        print('⚠️ AlaCarteQR: Failed to get active profile, trying alternative method: $profileError');
        
        // Fallback: Try to get userId from storage
        final userId = await StorageHelper.getUserId();
        print('📦 AlaCarteQR: UserId from storage: $userId');
        
        if (userId != null) {
          // Use userId with a default profile name or fetch from API
          setState(() {
            _qrData = 'https://api.menusidekick.app/api/dining-profile/$userId/default/';
            _isLoading = false;
          });
          print('✅ AlaCarteQR: Using fallback QR Data: $_qrData');
        } else {
          throw Exception('No user ID found in storage');
        }
      }
    } catch (e, stackTrace) {
      print('❌ AlaCarteQR: Error loading QR data: $e');
      print('❌ AlaCarteQR: Stack trace: $stackTrace');
      
      setState(() {
        _qrData = 'https://api.menusidekick.app/api/dining-profile/error/error/';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

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
                onPressed: () => context.go(RoutePath.home.addBasePath),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.restaurant, color: Color(0xFF1F2937), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    l10n.alaCarte,
                    textAlign: TextAlign.center,
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

      /// BODY
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE27B4F)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  /// QR CODE CONTAINER
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _qrData ?? '',
                      version: QrVersions.auto,
                      size: 250.0,
                      backgroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// DESCRIPTION TEXT
                  Text(
                    l10n.scanQRDescription,
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
                        l10n.shareQRCode,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  void _shareQRCode(BuildContext context) {
    if (_qrData == null) return;
    
    final l10n = AppLocalizations.of(context)!;

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: _qrData!)).then((_) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.qrCodeSharedSuccess,
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

    // Share via system
    Future.delayed(const Duration(milliseconds: 500), () {
      Share.share(
        l10n.shareQRMessage(_qrData!),
        subject: l10n.shareQRSubject,
      );
    });
  }
}

/// =======================================
/// My QR Code Screen
/// =======================================
class MyQRCodeScreen extends StatefulWidget {
  final String? qrData;

  const MyQRCodeScreen({
    super.key,
    this.qrData,
  });

  @override
  State<MyQRCodeScreen> createState() => _MyQRCodeScreenState();
}

class _MyQRCodeScreenState extends State<MyQRCodeScreen> {
  String? _qrData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQRData();
  }

  Future<void> _loadQRData() async {
    try {
      if (widget.qrData != null) {
        setState(() {
          _qrData = widget.qrData;
          _isLoading = false;
        });
        return;
      }

      print('🔍 MyQRCode: Fetching active profile...');
      
      // Try to get active profile
      try {
        final activeProfile = await UserService.getActiveProfile();
        print('✅ MyQRCode: Active profile received: $activeProfile');
        
        final userId = activeProfile['userId'];
        final profileName = activeProfile['profileName'];
        
        print('✅ MyQRCode: userId=$userId, profileName=$profileName');
        
        setState(() {
          _qrData = 'https://api.menusidekick.app/api/dining-profile/$userId/$profileName/';
          _isLoading = false;
        });
        
        print('✅ MyQRCode: QR Data set to: $_qrData');
      } catch (profileError) {
        print('⚠️ MyQRCode: Failed to get active profile, trying alternative method: $profileError');
        
        // Fallback: Try to get userId from storage
        final userId = await StorageHelper.getUserId();
        print('📦 MyQRCode: UserId from storage: $userId');
        
        if (userId != null) {
          // Use userId with a default profile name or fetch from API
          setState(() {
            _qrData = 'https://api.menusidekick.app/api/dining-profile/$userId/default/';
            _isLoading = false;
          });
          print('✅ MyQRCode: Using fallback QR Data: $_qrData');
        } else {
          throw Exception('No user ID found in storage');
        }
      }
    } catch (e, stackTrace) {
      print('❌ MyQRCode: Error loading QR data: $e');
      print('❌ MyQRCode: Stack trace: $stackTrace');
      
      setState(() {
        _qrData = 'https://api.menusidekick.app/api/dining-profile/error/error/';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                l10n.myQRCode,
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

      /// BODY
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE27B4F)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  /// QR CODE CONTAINER
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: _qrData ?? '',
                      version: QrVersions.auto,
                      size: 250.0,
                      backgroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// DESCRIPTION TEXT
                  Text(
                    l10n.scanQRDescription,
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
                        l10n.shareQRCode,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  void _shareQRCode(BuildContext context) {
    if (_qrData == null) return;
    
    final l10n = AppLocalizations.of(context)!;

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: _qrData!)).then((_) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.qrCodeLinkCopied,
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

    // Share via system
    Future.delayed(const Duration(milliseconds: 500), () {
      Share.share(
        l10n.shareQRMessage(_qrData!),
        subject: l10n.shareQRSubject,
      );
    });
  }
}

/// =======================================
/// Navigation Helpers
/// =======================================
class QRCodeNavigation {
  static void toAlaCarteQR(BuildContext context, {String? qrData}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlaCarteQRScreen(
          qrData: qrData,
        ),
      ),
    );
  }

  static void toMyQRCode(BuildContext context, {String? qrData}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyQRCodeScreen(
          qrData: qrData,
        ),
      ),
    );
  }
}