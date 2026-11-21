import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'soil_logic.dart';

class ReportService {
  static const _key = 'saved_reports';

  static Future<void> save(SoilValues v) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.insert(
      0,
      jsonEncode({
        'date': DateTime.now().toIso8601String(),
        'n': v.n,
        'p': v.p,
        'k': v.k,
        'ph': v.ph,
        'oc': v.oc,
      }),
    );
    await prefs.setStringList(_key, list);
  }

  static Future<List<Map<String, dynamic>>> all() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    return list.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
