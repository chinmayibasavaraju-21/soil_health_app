import 'package:flutter/material.dart';

import 'scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _iconVisible = false;
  bool _textVisible = false;
  bool _cardVisible = false;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Staggered entrance
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _iconVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 320), () {
      if (mounted) setState(() => _textVisible = true);
    });
    Future.delayed(const Duration(milliseconds: 560), () {
      if (mounted) setState(() => _cardVisible = true);
    });

    // Continuous breathing pulse on the icon badge
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8D4E2A), Color(0xFFE08E45), Color(0xFFFFF3E0)],
            stops: [0.0, 0.42, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              children: [
                const SizedBox(height: 36),

                // Top icon badge — fades/scales in, then pulses forever
                AnimatedOpacity(
                  opacity: _iconVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: AnimatedScale(
                    scale: _iconVisible ? 1 : 0.7,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = 1.0 + (_pulseController.value * 0.07);
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.agriculture_rounded,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Title + subtitle, fades/slides in after the icon
                AnimatedOpacity(
                  opacity: _textVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOut,
                  child: AnimatedSlide(
                    offset: _textVisible ? Offset.zero : const Offset(0, 0.15),
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeOutCubic,
                    child: Column(
                      children: [
                        const Text(
                          'Soil Health Advisory',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Know your soil. Grow better.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Main white card, slides up last
                AnimatedOpacity(
                  opacity: _cardVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: AnimatedSlide(
                    offset: _cardVisible ? Offset.zero : const Offset(0, 0.1),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Welcome, Farmer! 🌾',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8D4E2A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Scan your Soil Health Card to get simple, voice-guided fertilizer recommendations in your own language.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _FeatureChip(
                                icon: Icons.camera_alt_rounded,
                                label: 'Scan',
                                color: const Color(0xFFE08E45),
                              ),
                              _FeatureChip(
                                icon: Icons.translate_rounded,
                                label: 'Translate',
                                color: const Color(0xFF5A9367),
                              ),
                              _FeatureChip(
                                icon: Icons.mic_rounded,
                                label: 'Speak',
                                color: const Color(0xFFD4572A),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          _AnimatedPressButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScanScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4572A),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFD4572A)
                                        .withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Scan Card',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () {
                              // Language selector — we'll build this next
                            },
                            icon: const Icon(
                              Icons.language,
                              size: 18,
                              color: Color(0xFF8D4E2A),
                            ),
                            label: const Text(
                              'English',
                              style: TextStyle(
                                color: Color(0xFF8D4E2A),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A button wrapper that shrinks slightly when pressed, for tactile feedback
class _AnimatedPressButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _AnimatedPressButton({required this.child, required this.onTap});

  @override
  State<_AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<_AnimatedPressButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
