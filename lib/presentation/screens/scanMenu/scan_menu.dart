import 'dart:io';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
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

  /// 🔹 multiple images list
  final List<File> _images = [];

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
    _cameras = widget.cameras ?? await availableCameras();
    _camera = CameraController(_cameras[_camIndex], ResolutionPreset.high, enableAudio: false);
    await _camera!.initialize();
    if (mounted) setState(() => _isReady = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              },
              onCapture: _capture,
              onOpenGallery: _openGallery,
              onToggleFlash: _toggleFlash,
              galleryAsset: Assets.images.gallery.path,
              flashAsset: _flashOn ? Assets.images.flash.path : Assets.images.flashoff.path,
              shutterAsset: Assets.images.shutter.path,
            ),

            /// ✅ Fixed Container (Photos + Run Scan)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: 84,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                color: const Color(0xFF6B7280), // Theme Gray
                child: Row(
                  children: [
                    /// 🔹 Scrollable photos list
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: Image.file(
                                  _images[index],
                                  width: 76,
                                  height: 48,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -12,
                                right: -12,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() => _images.removeAt(index));
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// 🔹 Run Scan Button
                    ElevatedButton(
                      onPressed: _images.isEmpty
                          ? null
                          : () => context.go(RoutePath.scanResultAll.addBasePath),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF287FBE),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.runScan,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  /// ✅ Capture Image
  Future<void> _capture() async {
    if (!_isReady || _capturing) return;
    setState(() => _capturing = true);
    try {
      final x = await _camera!.takePicture();
      setState(() {
        _images.add(File(x.path));
      });
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
    } catch (_) {}
  }

  /// ✅ Open Gallery
  Future<void> _openGallery() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) {
      setState(() {
        _images.add(File(x.path));
      });
    }
  }
}