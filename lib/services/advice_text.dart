import 'soil_logic.dart';

class AdviceText {
  // language code -> (speech code, display name)
  static const Map<String, String> speechCodes = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'kn': 'kn-IN',
  };
  static const Map<String, String> names = {
    'en': 'English',
    'hi': 'हिंदी',
    'kn': 'ಕನ್ನಡ',
  };

  // [low, medium, good] sentences for each nutrient
  static const Map<String, Map<String, List<String>>> _t = {
    'en': {
      'n': [
        'Nitrogen is low. Apply urea fertilizer.',
        'Nitrogen is medium. Apply a small amount of urea.',
        'Nitrogen is good. No urea needed.',
      ],
      'p': [
        'Phosphorus is low. Apply DAP fertilizer.',
        'Phosphorus is medium. Apply a small amount of DAP.',
        'Phosphorus is good. No DAP needed.',
      ],
      'k': [
        'Potash is low. Apply muriate of potash.',
        'Potash is medium. Apply a small amount of potash.',
        'Potash is good.',
      ],
      'oc': [
        'Organic carbon is low. Add farmyard manure or compost.',
        'Organic carbon is medium. Add some farmyard manure.',
        'Organic carbon is good.',
      ],
      'ph': [
        'The soil is acidic. Apply lime.',
        'Soil pH is good.',
        'The soil is alkaline. Apply gypsum and organic manure.',
      ],
    },
    'hi': {
      'n': [
        'नाइट्रोजन कम है। यूरिया खाद डालें।',
        'नाइट्रोजन मध्यम है। थोड़ी मात्रा में यूरिया डालें।',
        'नाइट्रोजन अच्छा है। यूरिया की ज़रूरत नहीं।',
      ],
      'p': [
        'फॉस्फोरस कम है। डीएपी खाद डालें।',
        'फॉस्फोरस मध्यम है। थोड़ी मात्रा में डीएपी डालें।',
        'फॉस्फोरस अच्छा है। डीएपी की ज़रूरत नहीं।',
      ],
      'k': [
        'पोटाश कम है। म्यूरेट ऑफ पोटाश डालें।',
        'पोटाश मध्यम है। थोड़ा पोटाश डालें।',
        'पोटाश अच्छा है।',
      ],
      'oc': [
        'जैविक कार्बन कम है। गोबर की खाद या कम्पोस्ट डालें।',
        'जैविक कार्बन मध्यम है। कुछ गोबर की खाद डालें।',
        'जैविक कार्बन अच्छा है।',
      ],
      'ph': [
        'मिट्टी अम्लीय है। चूना डालें।',
        'मिट्टी का पीएच सही है।',
        'मिट्टी क्षारीय है। जिप्सम और जैविक खाद डालें।',
      ],
    },
    'kn': {
      'n': [
        'ಸಾರಜನಕ ಕಡಿಮೆ ಇದೆ. ಯೂರಿಯಾ ಗೊಬ್ಬರ ಹಾಕಿ.',
        'ಸಾರಜನಕ ಮಧ್ಯಮ ಇದೆ. ಸ್ವಲ್ಪ ಯೂರಿಯಾ ಹಾಕಿ.',
        'ಸಾರಜನಕ ಚೆನ್ನಾಗಿದೆ. ಯೂರಿಯಾ ಬೇಕಾಗಿಲ್ಲ.',
      ],
      'p': [
        'ರಂಜಕ ಕಡಿಮೆ ಇದೆ. ಡಿಎಪಿ ಗೊಬ್ಬರ ಹಾಕಿ.',
        'ರಂಜಕ ಮಧ್ಯಮ ಇದೆ. ಸ್ವಲ್ಪ ಡಿಎಪಿ ಹಾಕಿ.',
        'ರಂಜಕ ಚೆನ್ನಾಗಿದೆ. ಡಿಎಪಿ ಬೇಕಾಗಿಲ್ಲ.',
      ],
      'k': [
        'ಪೊಟ್ಯಾಶ್ ಕಡಿಮೆ ಇದೆ. ಮ್ಯೂರೇಟ್ ಆಫ್ ಪೊಟ್ಯಾಶ್ ಹಾಕಿ.',
        'ಪೊಟ್ಯಾಶ್ ಮಧ್ಯಮ ಇದೆ. ಸ್ವಲ್ಪ ಪೊಟ್ಯಾಶ್ ಹಾಕಿ.',
        'ಪೊಟ್ಯಾಶ್ ಚೆನ್ನಾಗಿದೆ.',
      ],
      'oc': [
        'ಸಾವಯವ ಇಂಗಾಲ ಕಡಿಮೆ ಇದೆ. ಕೊಟ್ಟಿಗೆ ಗೊಬ್ಬರ ಅಥವಾ ಕಾಂಪೋಸ್ಟ್ ಹಾಕಿ.',
        'ಸಾವಯವ ಇಂಗಾಲ ಮಧ್ಯಮ ಇದೆ. ಸ್ವಲ್ಪ ಕೊಟ್ಟಿಗೆ ಗೊಬ್ಬರ ಹಾಕಿ.',
        'ಸಾವಯವ ಇಂಗಾಲ ಚೆನ್ನಾಗಿದೆ.',
      ],
      'ph': [
        'ಮಣ್ಣು ಆಮ್ಲೀಯವಾಗಿದೆ. ಸುಣ್ಣ ಹಾಕಿ.',
        'ಮಣ್ಣಿನ ಪಿಎಚ್ ಸರಿಯಾಗಿದೆ.',
        'ಮಣ್ಣು ಕ್ಷಾರೀಯವಾಗಿದೆ. ಜಿಪ್ಸಂ ಮತ್ತು ಸಾವಯವ ಗೊಬ್ಬರ ಹಾಕಿ.',
      ],
    },
  };

  static int _idx(Level l) => l == Level.low ? 0 : (l == Level.medium ? 1 : 2);

  /// Returns a list of sentences in the chosen language.
  static List<String> build(SoilValues v, String lang) {
    final t = _t[lang]!;
    final out = <String>[];
    if (v.n != null) out.add(t['n']![_idx(SoilLogic.nitrogenLevel(v.n!))]);
    if (v.p != null) out.add(t['p']![_idx(SoilLogic.phosphorusLevel(v.p!))]);
    if (v.k != null) out.add(t['k']![_idx(SoilLogic.potassiumLevel(v.k!))]);
    if (v.oc != null)
      out.add(t['oc']![_idx(SoilLogic.organicCarbonLevel(v.oc!))]);
    if (v.ph != null) {
      final i = v.ph! < 6.5 ? 0 : (v.ph! > 7.5 ? 2 : 1);
      out.add(t['ph']![i]);
    }
    return out;
  }
}
