import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const Color primaryGreen = Color(0xFF2E7D4F);
  static const Color darkGreen = Color(0xFF1F5E3A);
  static const Color bgGreen = Color(0xFFF2F9F4);

  // Dummy data for now — Thanusha will replace this with real OCR + logic output
  static const List<Map<String, String>> soilData = [
    {'param': 'Nitrogen (N)', 'value': '218 kg/ha', 'status': 'Low'},
    {'param': 'Phosphorus (P)', 'value': '24 kg/ha', 'status': 'Good'},
    {'param': 'Potassium (K)', 'value': '180 kg/ha', 'status': 'Medium'},
    {'param': 'pH', 'value': '6.8', 'status': 'Good'},
    {'param': 'Organic Carbon', 'value': '0.52 %', 'status': 'Medium'},
  ];

  static const List<Map<String, String>> recommendations = [
    {'label': 'Nitrogen (N)', 'detail': 'Urea (46% N) — 50 kg/acre'},
    {'label': 'Phosphorus (P)', 'detail': 'DAP (18-46-0) — 25 kg/acre'},
    {'label': 'Potassium (K)', 'detail': 'MOP (60% K) — 25 kg/acre'},
  ];

  static const List<String> otherSuggestions = [
    'Add organic manure (FYM/compost)',
    'Maintain soil pH between 6.5 - 7.5',
    'Follow balanced fertilization for better yield',
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Low':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Good':
      default:
        return primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
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
