// lib/services/soil_logic.dart
// Parses OCR text from a Soil Health Card and builds fertilizer advice.
// Pure Dart: no packages, works in Chrome, on Windows and on Android.

enum Level { low, medium, high }

class SoilValues {
  final double? n; // kg/ha
  final double? p; // kg/ha
  final double? k; // kg/ha
  final double? ph;
  final double? oc; // %

  const SoilValues({this.n, this.p, this.k, this.ph, this.oc});

  bool get isEmpty =>
      n == null && p == null && k == null && ph == null && oc == null;
}

class Recommendation {
  final String nutrient; // "Nitrogen (N)"
  final Level level;
  final String advice; // "Urea (46% N) - 50 kg/acre"

  const Recommendation(this.nutrient, this.level, this.advice);
}

class SoilLogic {
  // ---------- 1. Read numbers out of OCR text ----------

  static double? _find(String text, List<String> keywords) {
    for (final kw in keywords) {
      // keyword, up to ~40 non-digit chars (units, brackets, colons), then a number
      final re = RegExp(
        kw + r'[^0-9\n]{0,40}?(\d+(?:[.,]\d+)?)',
        caseSensitive: false,
      );
      final m = re.firstMatch(text);
      if (m != null) {
        return double.tryParse(m.group(1)!.replaceAll(',', '.'));
      }
    }
    return null;
  }

  static SoilValues parse(String rawText) {
    // OCR often mixes up O/0 and l/1 inside numbers; keep it simple and tolerant.
    final text = rawText.replaceAll('\r', '\n');
    return SoilValues(
      n: _find(text, ['nitrogen', r'\bN\b']),
      p: _find(text, ['phosphorus', 'phosphorous', r'\bP\b']),
      k: _find(text, ['potassium', r'\bK\b']),
      ph: _find(text, [r'\bpH\b']),
      oc: _find(text, ['organic\\s*carbon', r'\bOC\b']),
    );
  }

  // ---------- 2. Classify levels ----------
  // Thresholds follow the commonly used Soil Health Card ratings.
  // Double-check them against your dataset / the official card before the demo.

  static Level nitrogenLevel(double v) =>
      v < 280 ? Level.low : (v <= 560 ? Level.medium : Level.high);

  static Level phosphorusLevel(double v) =>
      v < 10 ? Level.low : (v <= 25 ? Level.medium : Level.high);

  static Level potassiumLevel(double v) =>
      v < 110 ? Level.low : (v <= 280 ? Level.medium : Level.high);

  static Level organicCarbonLevel(double v) =>
      v < 0.5 ? Level.low : (v <= 0.75 ? Level.medium : Level.high);

  /// pH is not low/medium/high: returns a short label instead.
  static String phLabel(double v) =>
      v < 6.5 ? 'Acidic' : (v <= 7.5 ? 'Good' : 'Alkaline');

  // ---------- 3. Build advice ----------
  // Doses are generic placeholders (kg/acre). Replace with doses from a
  // trusted source (state agriculture dept / ICAR) before real use.

  static List<Recommendation> recommend(SoilValues s) {
    final out = <Recommendation>[];

    if (s.n != null) {
      final lvl = nitrogenLevel(s.n!);
      out.add(
        Recommendation('Nitrogen (N)', lvl, switch (lvl) {
          Level.low => 'Urea (46% N) - 50 kg/acre',
          Level.medium => 'Urea (46% N) - 25 kg/acre',
          Level.high => 'No nitrogen fertilizer needed',
        }),
      );
    }
    if (s.p != null) {
      final lvl = phosphorusLevel(s.p!);
      out.add(
        Recommendation('Phosphorus (P)', lvl, switch (lvl) {
          Level.low => 'DAP (18-46-0) - 50 kg/acre',
          Level.medium => 'DAP (18-46-0) - 25 kg/acre',
          Level.high => 'No phosphorus fertilizer needed',
        }),
      );
    }
    if (s.k != null) {
      final lvl = potassiumLevel(s.k!);
      out.add(
        Recommendation('Potassium (K)', lvl, switch (lvl) {
          Level.low => 'MOP (60% K) - 40 kg/acre',
          Level.medium => 'MOP (60% K) - 25 kg/acre',
          Level.high => 'No potassium fertilizer needed',
        }),
      );
    }
    return out;
  }

  /// General tips shown under the fertilizer list.
  static List<String> tips(SoilValues s) {
    final t = <String>[];
    if (s.oc != null && organicCarbonLevel(s.oc!) != Level.high) {
      t.add('Add organic manure (FYM/compost)');
    }
    if (s.ph != null) {
      if (s.ph! < 6.5)
        t.add('Soil is acidic: consider applying lime');
      else if (s.ph! > 7.5)
        t.add('Soil is alkaline: consider gypsum and organic matter');
      else
        t.add('Maintain soil pH between 6.5 - 7.5');
    }
    t.add('Follow balanced fertilization for better yield');
    return t;
  }
}

// ---- Quick test (run with: dart run lib/services/soil_logic.dart) ----
void main() {
  const sample = '''
Soil Health Card
Available Nitrogen (N): 218 kg/ha
Available Phosphorus (P): 24 kg/ha
Available Potassium (K): 180 kg/ha
pH 6.8
Organic Carbon (OC) 0.52 %
''';
  final v = SoilLogic.parse(sample);
  print('N=${v.n} P=${v.p} K=${v.k} pH=${v.ph} OC=${v.oc}');
  for (final r in SoilLogic.recommend(v)) {
    print('${r.nutrient} [${r.level.name}]: ${r.advice}');
  }
  print(SoilLogic.tips(v));
}
