import 'dart:io';
import 'package:MenuSideKick/core/routes/routes.dart';
import 'package:MenuSideKick/presentation/screens/scanMenu/widgets/scan_menu_help_dialog.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/custom_assets/assets.gen.dart';
import '../../../core/routes/route_path.dart';
import 'package:go_router/go_router.dart';

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

    _camera = CameraController(_cameras[_camIndex], ResolutionPreset.high,
        enableAudio: false);

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
            _topBar(), // ✅ এখন টপ বার অ্যাড করলাম
            _bottomControls(),
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

  /// ✅ Rounded Close + Help Button
  Widget _topBar() => Positioned(
    top: 12,
    left: 12,
    right: 12,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _roundIconBtn(Icons.close,
                () => context.go(RoutePath.home.addBasePath)),
        _roundIconBtn(Icons.help_outline, _helpDialog),
      ],
    ),
  );

  Widget _roundIconBtn(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: CircleAvatar(
      backgroundColor: Colors.white24,
      radius: 20,
      child: Icon(icon, color: Colors.white),
    ),
  );

  void _helpDialog() => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const ScanMenuHelpDialog(),
  );

  Widget _bottomControls() => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: SlideTransition(
      position: _slideAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Position the menu within the frame",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _modeButton("Photo"),
                const SizedBox(width: 12),
                _modeButton("PDF"),
                const SizedBox(width: 12),
                _modeButton("URL"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _roundImageBtn(Assets.images.gallery.path, _openGallery),
                ScaleTransition(scale: _pulseAnim, child: _captureBtn()),
                _roundImageBtn(Assets.images.flash.path, _toggleFlash,
                    isFlash: true),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _roundImageBtn(String asset, VoidCallback onTap,
      {bool isFlash = false}) =>
      InkWell(
        onTap: onTap,
        child: CircleAvatar(
          child: Image.asset(asset, width: 56, height: 56),
        ),
      );

  Widget _captureBtn() => GestureDetector(
    onTap: () async {
      await _capture();
      _showBottomSheet();
    },
    child: Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.shutter.path),
          fit: BoxFit.contain,
        ),
      ),
    ),
  );

  Widget _modeButton(String title) => GestureDetector(
    onTap: () {
      setState(() => _mode = title);
      _showBottomSheet();
    },
    child: Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: _mode == title ? Colors.blue : Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );

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
                child: Image.file(_image!,
                    width: 76, height: 48, fit: BoxFit.cover),
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
              onPressed: () =>
                  context.go(RoutePath.scanResultAll.addBasePath), // ✅ Updated
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF287FBE),
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Future<void> _toggleFlash() async {
    if (!_isReady) return;
    try {
      await _camera!.setFlashMode(_flashOn ? FlashMode.off : FlashMode.torch);
      setState(() => _flashOn = !_flashOn);
    } catch (_) {
      _msg("Flash failed", false);
    }
  }

  Future<void> _openGallery() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x != null) {
      _image = File(x.path);
      _msg("Image selected", true);
      _showBottomSheet();
    }
  }

  void _msg(String m, bool ok) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(m),
        backgroundColor: ok ? Colors.green : Colors.red),
  );
}
