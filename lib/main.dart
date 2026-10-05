import 'package:flutter/material.dart';

void main() {
  runApp(const SoilHealthApp());
}

class SoilHealthApp extends StatelessWidget {
  const SoilHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soil Health Advisory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8D4E2A), // deep terracotta brown
              Color(0xFFE08E45), // warm orange
              Color(0xFFFFF3E0), // soft cream at bottom
            ],
            stops: [0.0, 0.42, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              children: [
                const SizedBox(height: 36),
                // Top icon badge
                Container(
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
                const SizedBox(height: 16),
                const Text(
                  'Soil Health Advisory',
                  style: TextStyle(
                    fontSize: 23,
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
                  ),
                ),
                const Spacer(),

                // Main white card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
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
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 26),

                      // Row of 3 colorful feature chips
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
                      const SizedBox(height: 26),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // We'll connect this to the scan screen next
                          },
                          icon: const Icon(Icons.camera_alt_rounded),
                          label: const Text('Scan Card'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            backgroundColor: const Color(0xFFD4572A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
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
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
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
