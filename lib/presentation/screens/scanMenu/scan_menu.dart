import 'dart:io';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import 'widgets/scan_menu_help_dialog.dart';
import 'widgets/scan_menu_top_bar.dart';
import 'widgets/scan_menu_bottom_controls.dart';

class ScanMenuScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const ScanMenuScreen({super.key, this.cameras});

  @override
  State<ScanMenuScreen> createState() => _ScanMenuScreenState();
}

class _ScanMenuScreenState extends State<ScanMenuScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _camera;
  List<CameraDescription> _cameras = [];
  final int _camIndex = 0;

  bool _isReady = false, _flashOn = false, _capturing = false;
  String _mode = "Photo";
  File? _image;

  late final AnimationController _slideCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    _slideCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_camera == null || !_camera!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) _camera?.dispose();
    if (state == AppLifecycleState.resumed) _initCamera();
  }

  Future<void> _initCamera() async {
    final permission = await Permission.camera.request();
    if (!permission.isGranted) return _msg("Camera permission required", false);

    _cameras = widget.cameras ?? await availableCameras();
    if (_cameras.isEmpty) return _msg("No cameras available", false);

    _camera = CameraController(_cameras[_camIndex], ResolutionPreset.high, enableAudio: false);

    await _camera!.initialize();
    if (mounted) setState(() => _isReady = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _cameraPreview(),

            /// ✅ Top Bar (Close + Help)
            ScanMenuTopBar(
              onClose: () => context.go(RoutePath.home.addBasePath),
              onHelp: _helpDialog,
            ),

            /// ✅ Bottom Controls (Gallery, Capture, Flash)
            ScanMenuBottomControls(
              slideAnim: _slideAnim,
              pulseAnim: _pulseAnim,
              selectedMode: _mode,
              onModeChange: (value) {
                setState(() => _mode = value);
                _showBottomSheet();
              },
              onCapture: () async {
                await _capture();
                _showBottomSheet();
              },
              onOpenGallery: _openGallery,
              onToggleFlash: _toggleFlash,
              galleryAsset: Assets.images.gallery.path,
              flashAsset: Assets.images.flash.path,
              shutterAsset: Assets.images.shutter.path,
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Camera Preview Widget
  Widget _cameraPreview() => !_isReady
      ? const Center(child: CircularProgressIndicator(color: Colors.blue))
      : SizedBox.expand(
    child: FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _camera!.value.previewSize!.height,
        height: _camera!.value.previewSize!.width,
        child: CameraPreview(_camera!),
      ),
    ),
  );

  /// ✅ Help Dialog
  void _helpDialog() => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const ScanMenuHelpDialog(),
  );

  /// ✅ Bottom Sheet after capture
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Container(
        width: 390,
        height: 84,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(_image!, width: 76, height: 48, fit: BoxFit.cover),
              )
            else
              Container(
                width: 76,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ElevatedButton(
              onPressed: () => context.go(RoutePath.scanResultAll.addBasePath),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF287FBE),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Run Scan",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Capture Image
  Future<void> _capture() async {
    if (!_isReady || _capturing) return;
    setState(() => _capturing = true);
    try {
      final x = await _camera!.takePicture();
      _image = File(x.path);
      _msg("Image captured!", true);
    } catch (e) {
      _msg("Capture failed", false);
    } finally {
      setState(() => _capturing = false);
    }
  }

  /// ✅ Toggle Flash
  Future<void> _toggleFlash() async {
    if (!_isReady) return;
    try {
      await _camera!.setFlashMode(_flashOn ? FlashMode.off : FlashMode.torch);
      setState(() => _flashOn = !_flashOn);
    } catch (_) {
      _msg("Flash failed", false);
    }
  }

  /// ✅ Open Gallery
  Future<void> _openGallery() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) {
      _image = File(x.path);
      _msg("Image selected", true);
      _showBottomSheet();
    }
  }

  /// ✅ Snack Message
  void _msg(String m, bool ok) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(m, style: GoogleFonts.poppins(color: Colors.white)),
      backgroundColor: ok ? Colors.green : Colors.red,
    ),
  );
}
