import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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
  final String _mode = "Photo";
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
            _topBar(),
            _bottomControls(),
          ],
        ),
      ),
    );
  }

  /// ================== UI ==================
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

  Widget _topBar() => Positioned(
    top: 12,
    left: 12,
    right: 12,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _roundIconBtn(Icons.close, () => Navigator.pop(context)),
        _roundIconBtn(Icons.help_outline, _helpDialog),
      ],
    ),
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
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _roundIconBtn(Icons.photo, _openGallery),
                ScaleTransition(scale: _pulseAnim, child: _captureBtn()),
                _roundIconBtn(
                    _flashOn ? Icons.flash_on : Icons.flash_off,
                    _toggleFlash),
              ],
            ),
            const SizedBox(height: 20),
            _primaryBtn("Run Scan", _runScan),
          ],
        ),
      ),
    ),
  );

  /// ================== Widgets ==================
  Widget _roundIconBtn(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(30),
    child: CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey.shade700,
      child: Icon(icon, color: Colors.white),
    ),
  );

  Widget _captureBtn() => GestureDetector(
    onTap: _capture,
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent, width: 4),
      ),
      child: _capturing
          ? const CircularProgressIndicator(color: Colors.blue)
          : null,
    ),
  );

  Widget _primaryBtn(String t, VoidCallback f) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: f,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        t,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );

  /// ================== Functions ==================
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
    }
  }

  Future<void> _runScan() async {
    if (_image == null) return _msg("Capture image first", false);

    if (_mode == "PDF") {
      final pdf = pw.Document();
      final Uint8List imgBytes = await _image!.readAsBytes();

      pdf.addPage(
        pw.Page(
          build: (_) => pw.Center(
            child: pw.Image(pw.MemoryImage(imgBytes)),
          ),
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final f = File("${dir.path}/scan.pdf");
      await f.writeAsBytes(await pdf.save());

      _msg("PDF saved: ${f.path}", true);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      _msg("Image processed!", true);
    }
  }

// Replace the existing _helpDialog() function in your ScanMenuScreen with this:

  void _helpDialog() => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5DC), // Cream background like image
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🌿", style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      "Tips for a Clear Scan",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🌿", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Center(
                child: Text(
                  "Your dining sidekick works best when the menu is easy to see. Here's how to glow it up:",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF8B7355),
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tips List
              _buildTipItem("✨", "Flat & Steady", "Place the menu flat, hold the phone steady.", const Color(0xFFFFCA28)),
              const SizedBox(height: 16),

              _buildTipItem("✨", "Good Lighting", "Natural light is best. Avoid strong reflections.", const Color(0xFFFFCA28)),
              const SizedBox(height: 16),

              _buildTipItem("✨", "No Cropping", "Capture the whole page edge to edge.", const Color(0xFF10B981)),
              const SizedBox(height: 16),

              _buildTipItem("✨", "Sharp & Clear", "Make sure the text is legible for best results.", const Color(0xFFFFCA28)),
              const SizedBox(height: 20),

              // Special message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE7F3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF472B6)),
                ),
                child: Row(
                  children: [
                    const Text("🌸", style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF831843),
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(
                              text: "Think of it as taking a photo for friend- ",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: "clear, bright, and cozy. The clearer the shot, the better we can guide you!",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🌸", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Choose How to Scan section
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose How to Scan",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("🦋", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Scanning options
              _buildScanOption("📷", "Photo", "Place the menu flat, hold the phone steady.", const Color(0xFFE27B4F)),
              const SizedBox(height: 12),

              _buildScanOption("📄", "PDF", "Natural light is best. Avoid strong reflections.", const Color(0xFFF59E0B)),
              const SizedBox(height: 12),

              _buildScanOption("🔗", "URL", "Capture the whole page edge to edge.", const Color(0xFF8B7355)),

              const SizedBox(height: 24),

              // Close button
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Got it!",
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
    ),
  );

// Helper widget for tip items
  Widget _buildTipItem(String emoji, String title, String description, Color accentColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF8B7355),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: "$title – ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
                TextSpan(
                  text: description,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

// Helper widget for scan options
  Widget _buildScanOption(String emoji, String title, String description, Color accentColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 16)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF8B7355),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _msg(String m, bool ok) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text(m),
        backgroundColor: ok ? Colors.green : Colors.red),
  );
}
