import 'package:flutter/material.dart';

import '../services/soil_logic.dart';

class ResultScreen extends StatelessWidget {
  // Pass the OCR text here later: ResultScreen(scannedText: ocrText).
  // If null, the sample text below is used so the screen still works.
  const ResultScreen({super.key, this.scannedText});

  final String? scannedText;

  static const Color primaryGreen = Color(0xFF2E7D4F);
  static const Color darkGreen = Color(0xFF1F5E3A);
  static const Color bgGreen = Color(0xFFF2F9F4);

  // Sample card text, used until real OCR text is passed in.
  static const String _sampleText = '''
Available Nitrogen (N): 218 kg/ha
Available Phosphorus (P): 24 kg/ha
Available Potassium (K): 180 kg/ha
pH 6.8
Organic Carbon (OC) 0.52 %
''';

  String _statusFor(Level l) {
    switch (l) {
      case Level.low:
        return 'Low';
      case Level.medium:
        return 'Medium';
      case Level.high:
        return 'Good';
    }
  }

  String _num(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  Color _statusColor(String status) {
    switch (status) {
      case 'Low':
        return Colors.red;
      case 'Medium':
      case 'Acidic':
      case 'Alkaline':
        return Colors.orange;
      case 'Good':
      default:
        return primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final values = SoilLogic.parse(scannedText ?? _sampleText);

    final List<Map<String, String>> soilData = [
      if (values.n != null)
        {
          'param': 'Nitrogen (N)',
          'value': '${_num(values.n!)} kg/ha',
          'status': _statusFor(SoilLogic.nitrogenLevel(values.n!)),
        },
      if (values.p != null)
        {
          'param': 'Phosphorus (P)',
          'value': '${_num(values.p!)} kg/ha',
          'status': _statusFor(SoilLogic.phosphorusLevel(values.p!)),
        },
      if (values.k != null)
        {
          'param': 'Potassium (K)',
          'value': '${_num(values.k!)} kg/ha',
          'status': _statusFor(SoilLogic.potassiumLevel(values.k!)),
        },
      if (values.ph != null)
        {
          'param': 'pH',
          'value': _num(values.ph!),
          'status': SoilLogic.phLabel(values.ph!),
        },
      if (values.oc != null)
        {
          'param': 'Organic Carbon',
          'value': '${_num(values.oc!)} %',
          'status': _statusFor(SoilLogic.organicCarbonLevel(values.oc!)),
        },
    ];

    final List<Map<String, String>> recommendations = SoilLogic.recommend(
      values,
    ).map((r) => {'label': r.nutrient, 'detail': r.advice}).toList();

    final List<String> otherSuggestions = SoilLogic.tips(values);

    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                const Text(
                  'Soil Health Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Analyzed badge
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle_rounded, color: primaryGreen),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Soil Health Card Analyzed',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Summary table
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Soil Health Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...soilData.map((row) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              row['param']!,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              row['value']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(row['status']!)
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  row['status']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(row['status']!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Recommendations
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended for Your Soil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Based on your nutrient levels and soil health card',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  const SizedBox(height: 14),
                  ...recommendations.map(
                    (rec) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.eco_rounded,
                            size: 16,
                            color: primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${rec['label']}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: rec['detail']),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 6),
                  ...otherSuggestions.map(
                    (s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 16,
                            color: primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              s,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Translate / Speak buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Ashrin — hook Bhashini translation here
                    },
                    icon: const Icon(
                      Icons.translate_rounded,
                      color: primaryGreen,
                    ),
                    label: const Text(
                      'Translate',
                      style: TextStyle(color: primaryGreen),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Ashrin — hook Bhashini text-to-speech here
                    },
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Speak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
