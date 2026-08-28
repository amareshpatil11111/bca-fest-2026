import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // --- Supabase Direct REST API Credentials ---
  static const String _supabaseUrl =
      'https://tpwiwcborqppghvbrzvl.supabase.co';
  static const String _supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRwd2l3Y2JvcnFwcGdodmJyenZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODc4MTg1OTQsImV4cCI6MjEwMzM5NDU5NH0'
      '.MbZxhWQrnLaM9TI4Fdetby1xOW4_CtkqC8ROJa5eoCA';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'apikey': _supabaseKey,
        'Authorization': 'Bearer $_supabaseKey',
        'Prefer': 'return=representation',
      };

  /// Register a participant — saves directly to Supabase REST API
  static Future<bool> registerParticipant({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final url = Uri.parse('$_supabaseUrl/rest/v1/registrations');
      debugPrint('📡 POST $url');

      final response = await http
          .post(
            url,
            headers: _headers,
            body: jsonEncode({'name': name, 'email': email, 'phone': phone}),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('📬 Status: ${response.statusCode}');
      debugPrint('📬 Body:   ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Registration saved to Supabase successfully!');
        return true;
      } else {
        debugPrint('❌ Supabase error ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Network error: $e');
      return false;
    }
  }
}
