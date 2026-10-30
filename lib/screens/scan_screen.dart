import 'package:flutter/material.dart';

import '../services/ocr_service.dart';
import '../services/soil_logic.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  static const Color primaryGreen = Color(0xFF2E7D4F);
  static const Color bgGreen = Color(0xFFF2F9F4);

  final OcrService _ocr = OcrService();
  bool _captured = false;
  bool _busy = false;
  String? _scannedText; // null = use sample data (Chrome / no OCR)

  @override
  void dispose() {
    _ocr.dispose();
    super.dispose();
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _scan({required bool fromCamera}) async {
    setState(() => _busy = true);
    try {
      final text = await _ocr.pickAndRead(fromCamera: fromCamera);
      if (text == null) return; // user cancelled

      if (SoilLogic.parse(text).isEmpty) {
        _showMessage(
          "Couldn't find soil values. Try a clearer, well-lit photo of the card.",
        );
        return;
      }
      if (!mounted) return;
      setState(() {
        _scannedText = text;
        _captured = true;
      });
    } on UnsupportedError {
      // Chrome / Windows: OCR is not available, so demo with sample data.
      if (!mounted) return;
      setState(() {
        _scannedText = null;
        _captured = true;
      });
      _showMessage('OCR works on a phone only. Using sample data.');
    } catch (e) {
      _showMessage('Could not read the card. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const Text(
                    'Scan Soil Health Card',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Align your Soil Health Card\nMake sure all four corners are visible and the text is clear.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Camera frame with corner brackets
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _captured
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: primaryGreen,
                                    size: 60,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Card captured successfully!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.credit_card_rounded,
                                size: 60,
                                color: Colors.black26,
                              ),
                            ),
                    ),
                    // Corner brackets
                    ..._buildCorners(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _busy ? null : () => _scan(fromCamera: true),
                  icon: const Icon(Icons.camera_alt_rounded),
                  label: Text(
                    _busy
                        ? 'Reading card...'
                        : (_captured ? 'Retake Card' : 'Capture Card'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _scan(fromCamera: false),
                  icon: const Icon(Icons.image_outlined, color: primaryGreen),
                  label: const Text(
                    'Upload from Gallery',
                    style: TextStyle(color: primaryGreen),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _captured
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResultScreen(scannedText: _scannedText),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Continue'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.black12,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

  List<Widget> _buildCorners() {
    const double size = 26;
    const double thickness = 3;
    const Color color = primaryGreen;

    Widget corner({required bool top, required bool left}) {
      return Positioned(
        top: top ? 16 : null,
        bottom: top ? null : 16,
        left: left ? 16 : null,
        right: left ? null : 16,
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CornerPainter(
              top: top,
              left: left,
              thickness: thickness,
              color: color,
            ),
          ),
        ),
      );
    }

    return [
      corner(top: true, left: true),
      corner(top: true, left: false),
      corner(top: false, left: true),
      corner(top: false, left: false),
    ];
  }
}

class _CornerPainter extends CustomPainter {
  final bool top;
  final bool left;
  final double thickness;
  final Color color;

  _CornerPainter({
    required this.top,
    required this.left,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
