// lib/presentation/screens/scanMenu/scan_menu.dart
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/controllers/scan_menu_controller.dart';
import '../../../core/controllers/subscription_controller.dart';
import '../subscription/widget/expired_subscription_popup.dart';
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
  final SubscriptionController _subscriptionController = Get.put(SubscriptionController());

  late final AnimationController _slideCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _focusCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _pulseAnim;
  late final Animation<double> _focusScaleAnim;
  late final Animation<double> _focusOpacityAnim;

  bool _showFocusIndicator = true;
  Offset _focusPoint = const Offset(0.5, 0.5);
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scanController.resetScan();

    // Check subscription status
    _checkSubscription();

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _focusCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _focusScaleAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _focusCtrl, curve: Curves.easeInOut),
    );

    _focusOpacityAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _focusCtrl, curve: Curves.easeInOut),
    );

    _initCamera();
  }

  /// Check subscription status and show popup if needed
  Future<void> _checkSubscription() async {
    // Wait a bit for the screen to load
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if subscription is needed
    if (_subscriptionController.needsSubscription &&
        !_subscriptionController.hasActiveSubscription) {
      _showSubscriptionPopup();
    }
  }

  void _showSubscriptionPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SubscriptionRequiredPopup(
        onSubscribe: () {
          Navigator.pop(context);
          context.go(RoutePath.subscription.addBasePath);
        },
      ),
    );
  }

  @override
  void dispose() {
    _isDisposing = true;
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    _slideCtrl.dispose();
    _pulseCtrl.dispose();
    _focusCtrl.dispose();
    super.dispose();
  }

  Future<void> _disposeCamera() async {
    final camera = _camera;
    if (camera != null) {
      _camera = null;
      try {
        await camera.dispose();
      } catch (e) {
        debugPrint('Camera dispose error: $e');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isDisposing) return;

    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _disposeCamera().then((_) {
        if (mounted && !_isDisposing) {
          setState(() => _isReady = false);
        }
      });
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    if (_isDisposing) return;

    try {
      // Get available cameras
      if (widget.cameras != null && widget.cameras!.isNotEmpty) {
        _cameras = widget.cameras!;
      } else {
        try {
          _cameras = await availableCameras();
        } catch (e) {
          debugPrint('❌ Failed to get available cameras: $e');
          _cameras = [];
        }
      }

      if (_cameras.isEmpty) {
        debugPrint('❌ No cameras available');
        if (mounted && !_isDisposing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No camera available. Please check camera permissions.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
            }
          });
        }
        return;
      }

      // Dispose old camera first
      await _disposeCamera();

      if (_isDisposing || !mounted) return;

      // Add delay to ensure clean state
      await Future.delayed(const Duration(milliseconds: 100));

      if (_isDisposing || !mounted) return;

      // Create new camera instance
      final newCamera = CameraController(
        _cameras[_camIndex],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Initialize camera
      await newCamera.initialize();

      if (_isDisposing || !mounted) {
        await newCamera.dispose();
        return;
      }

      // Set camera properties
      if (newCamera.value.isInitialized) {
        try {
          await newCamera.setFocusMode(FocusMode.auto);
          await newCamera.setExposureMode(ExposureMode.auto);
        } catch (e) {
          debugPrint('Camera settings error: $e');
        }
      }

      // Update state
      _camera = newCamera;
      if (mounted && !_isDisposing) {
        setState(() => _isReady = true);
      }

      // Set initial focus point after a delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_isDisposing && context.size != null) {
          setState(() {
            _focusPoint = Offset(
              context.size!.width / 2,
              context.size!.height / 2,
            );
          });
        }
      });
    } catch (e) {
      debugPrint('❌ Camera initialization error: $e');
      if (mounted && !_isDisposing) {
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
            if (_showFocusIndicator)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),

            _cameraPreview(),

            if (_showFocusIndicator)
              AnimatedBuilder(
                animation: _focusCtrl,
                builder: (context, child) {
                  return Positioned(
                    left: _focusPoint.dx - 110,
                    top: _focusPoint.dy - 160,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _focusPoint = Offset(
                            (_focusPoint.dx + details.delta.dx).clamp(
                                110.0, MediaQuery.of(context).size.width - 110),
                            (_focusPoint.dy + details.delta.dy).clamp(
                                160.0, MediaQuery.of(context).size.height - 160),
                          );
                        });

                        _updateCameraFocus();
                      },
                      child: Transform.scale(
                        scale: _focusScaleAnim.value,
                        child: Opacity(
                          opacity: _focusOpacityAnim.value,
                          child: Container(
                            width: 220,
                            height: 320,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: _buildFocusCorners(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

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
                if (value == "PDF") {
                  _pickPdfFile();
                }
              },
              onCapture: _capture,
              onOpenGallery: _openGallery,
              onToggleFlash: _toggleFlash,
              galleryAsset: Assets.images.gallery.path,
              flashAsset:
              _flashOn ? Assets.images.flash.path : Assets.images.flashoff.path,
              shutterAsset: Assets.images.shutter.path,
            ),

            _buildBottomFileList(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusCorners() {
    return Stack(
      children: [
        // Top-left corner
        Positioned(
          top: -2,
          left: -2,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 4),
                left: BorderSide(color: Colors.white, width: 4),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
              ),
            ),
          ),
        ),
        // Top-right corner
        Positioned(
          top: -2,
          right: -2,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 4),
                right: BorderSide(color: Colors.white, width: 4),
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
              ),
            ),
          ),
        ),
        // Bottom-left corner
        Positioned(
          bottom: -2,
          left: -2,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 4),
                left: BorderSide(color: Colors.white, width: 4),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
        ),
        // Bottom-right corner
        Positioned(
          bottom: -2,
          right: -2,
          child: Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 4),
                right: BorderSide(color: Colors.white, width: 4),
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomFileList(AppLocalizations l10n) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(() {
        final images = _scanController.scannedImages;
        final pdfFiles = _scanController.scannedPdfs;
        final isScanning = _scanController.isScanning.value;
        final totalFiles = images.length + pdfFiles.length;

        return Container(
          width: double.infinity,
          height: 84,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          color: const Color(0xFF6B7280),
          child: Row(
            children: [
              Expanded(
                child: totalFiles == 0
                    ? const Center(
                  child: Text(
                    'No files captured',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                )
                    : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: totalFiles,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index < images.length) {
                      return _buildImageThumbnail(images[index], index);
                    } else {
                      final pdfIndex = index - images.length;
                      return _buildPdfThumbnail(pdfFiles[pdfIndex], pdfIndex);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: totalFiles == 0 || isScanning ? null : _runScanAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF287FBE),
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    );
  }

  Widget _buildImageThumbnail(dynamic image, int index) {
    return FutureBuilder<Uint8List>(
      future: image.readAsBytes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: 76,
            height: 48,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
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
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _scanController.removeImage(index),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPdfThumbnail(dynamic pdfFile, int index) {
    return Stack(
      children: [
        Container(
          width: 76,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.red.shade300),
          ),
          child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
        ),
        Positioned(
          top: -12,
          right: -12,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _scanController.removePdf(index),
          ),
        ),
      ],
    );
  }

  Widget _cameraPreview() {
    final camera = _camera;

    if (!_isReady || camera == null || !camera.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      );
    }

    return GestureDetector(
      onTapDown: _onTapToFocus,
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: camera.value.previewSize!.height,
            height: camera.value.previewSize!.width,
            child: CameraPreview(camera),
          ),
        ),
      ),
    );
  }

  void _updateCameraFocus() {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;

    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final offset = Offset(
          _focusPoint.dx / renderBox.size.width,
          _focusPoint.dy / renderBox.size.height,
        );
        camera.setFocusPoint(offset);
        camera.setExposurePoint(offset);
      }
    } catch (e) {
      debugPrint('Focus update error: $e');
    }
  }

  Future<void> _onTapToFocus(TapDownDetails details) async {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;

    try {
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final offset = Offset(
        details.localPosition.dx / renderBox.size.width,
        details.localPosition.dy / renderBox.size.height,
      );

      setState(() {
        _focusPoint = details.localPosition;
      });

      await camera.setFocusPoint(offset);
      await camera.setExposurePoint(offset);
      await camera.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('❌ Focus error: $e');
    }
  }

  Future<void> _pickPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        _scanController.addPdf(file);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF added: ${file.name}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ PDF picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick PDF file'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _mode = "Photo");
      }
    }
  }

  void _helpDialog() => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const ScanMenuHelpDialog(),
  );

  Future<void> _capture() async {
    final camera = _camera;
    if (!_isReady || _capturing || camera == null || !camera.value.isInitialized) {
      return;
    }

    setState(() => _capturing = true);
    try {
      final xFile = await camera.takePicture();
      _scanController.addImage(xFile);
    } catch (e) {
      debugPrint('❌ Capture error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to capture image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _capturing = false);
      }
    }
  }

  Future<void> _toggleFlash() async {
    final camera = _camera;
    if (!_isReady || camera == null || !camera.value.isInitialized) return;

    try {
      await camera.setFlashMode(_flashOn ? FlashMode.off : FlashMode.torch);
      if (mounted) {
        setState(() => _flashOn = !_flashOn);
      }
    } catch (e) {
      debugPrint('❌ Flash toggle error: $e');
    }
  }

  Future<void> _openGallery() async {
    try {
      final xFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (xFile != null) {
        _scanController.addImage(xFile);
      }
    } catch (e) {
      debugPrint('❌ Gallery picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image from gallery'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _runScanAndNavigate() async {
    // Check subscription before running scan
    if (_subscriptionController.needsSubscription &&
        !_subscriptionController.hasActiveSubscription) {
      _showSubscriptionPopup();
      return;
    }

    final success = await _scanController.runScan();

    if (!mounted) return;

    if (success) {
      context.go(RoutePath.scanResultAll.addBasePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scan failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}