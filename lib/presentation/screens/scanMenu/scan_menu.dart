// lib/presentation/screens/scanMenu/scan_menu.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/controllers/scan_menu_controller.dart';
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

  final ScanMenuController _scanController = Get.put(ScanMenuController());

  late final AnimationController _slideCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ✅ Reset scan data when entering screen
    _scanController.resetScan();

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

    // ✅ Initialize camera after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initCamera();
    });
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
    if (state == AppLifecycleState.inactive) {
      _camera?.dispose();
    }
    if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = widget.cameras ?? await availableCameras();

      // ✅ Dispose old camera before creating new one
      await _camera?.dispose();

      _camera = CameraController(
        _cameras[_camIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _camera!.initialize();

      if (mounted) {
        setState(() => _isReady = true);
      }
    } catch (e) {
      debugPrint('❌ Camera initialization error: $e');
      if (mounted) {
        setState(() => _isReady = false);
      }
    }
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

            ScanMenuTopBar(
              onClose: () => context.go(RoutePath.home.addBasePath),
              onHelp: _helpDialog,
            ),

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
              flashAsset:
              _flashOn ? Assets.images.flash.path : Assets.images.flashoff.path,
              shutterAsset: Assets.images.shutter.path,
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Obx(() {
                final images = _scanController.scannedImages;
                final isScanning = _scanController.isScanning.value;

                return Container(
                  width: double.infinity,
                  height: 84,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  color: const Color(0xFF6B7280),
                  child: Row(
                    children: [
                      Expanded(
                        child: images.isEmpty
                            ? const Center(
                          child: Text(
                            'No images captured',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        )
                            : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return FutureBuilder<Uint8List>(
                              future: images[index].readAsBytes(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox(
                                    width: 76,
                                    height: 48,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                }

                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(2),
                                      child: Image.memory(
                                        snapshot.data!,
                                        width: 76,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: -12,
                                      right: -12,
                                      child: IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.white,
                                            size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints:
                                        const BoxConstraints(),
                                        onPressed: () {
                                          _scanController
                                              .removeImage(index);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: images.isEmpty || isScanning
                            ? null
                            : _runScanAndNavigate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF287FBE),
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isScanning
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

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

  void _helpDialog() => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const ScanMenuHelpDialog(),
  );

  Future<void> _capture() async {
    if (!_isReady || _capturing) return;
    setState(() => _capturing = true);
    try {
      final xFile = await _camera!.takePicture();
      _scanController.addImage(xFile);
    } catch (e) {
      debugPrint('❌ Capture error: $e');
    } finally {
      setState(() => _capturing = false);
    }
  }

  Future<void> _toggleFlash() async {
    if (!_isReady) return;
    try {
      await _camera!.setFlashMode(_flashOn ? FlashMode.off : FlashMode.torch);
      setState(() => _flashOn = !_flashOn);
    } catch (e) {
      debugPrint('❌ Flash toggle error: $e');
    }
  }

  Future<void> _openGallery() async {
    try {
      final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        _scanController.addImage(xFile);
      }
    } catch (e) {
      debugPrint('❌ Gallery picker error: $e');
    }
  }

  Future<void> _runScanAndNavigate() async {
    final success = await _scanController.runScan();

    if (success && mounted) {
      context.go(RoutePath.scanResultAll.addBasePath);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scan failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}