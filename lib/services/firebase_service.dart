import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  // In-memory local database for mock fallback
  static final List<Map<String, String>> _mockDb = [];

  // Initialize Firebase core and services
  static Future<void> initialize() async {
    try {
      if (DefaultFirebaseOptions.isConfigured) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _isInitialized = true;
        debugPrint('Firebase successfully initialized!');
      } else {
        debugPrint('Firebase credentials not set in firebase_options.dart.');
        debugPrint('Running BCA Fest 2026 in standalone mock database mode.');
      }
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      debugPrint('Falling back to local mock services.');
    }
  }

  // Register participant
  static Future<bool> registerParticipant({
    required String name,
    required String email,
    required String phone,
  }) async {
    // Simulate network latency (1 second) for premium loading experience
    await Future.delayed(const Duration(seconds: 1));

    final registrationData = {
      'name': name,
      'email': email,
      'phone': phone,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (_isInitialized) {
      try {
        await FirebaseFirestore.instance
            .collection('registrations')
            .add(registrationData);
        
        // Log event in Analytics
        await logEvent(
          name: 'registration_submit',
          parameters: {'email': email},
        );
        
        debugPrint('Successfully registered in Firebase: $registrationData');
        return true;
      } catch (e) {
        debugPrint('Error writing to Firestore: $e. Falling back to local logging.');
      }
    }

    // Mock fallback database storage
    _mockDb.add(registrationData);
    debugPrint('Mock Database Storage Success:');
    debugPrint('----------------------------------');
    debugPrint('Name:  $name');
    debugPrint('Email: $email');
    debugPrint('Phone: $phone');
    debugPrint('Time:  ${registrationData['timestamp']}');
    debugPrint('----------------------------------');
    return true;
  }

  // Log custom analytics events
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (_isInitialized) {
      try {
        await FirebaseAnalytics.instance.logEvent(
          name: name,
          parameters: parameters,
        );
        debugPrint('Firebase Analytics Event Logged: $name $parameters');
      } catch (e) {
        debugPrint('Analytics error: $e');
      }
    } else {
      debugPrint('Mock Analytics Event: $name ($parameters)');
    }
  }

  // Log page/section views
  static Future<void> logSectionView(String sectionName) async {
    await logEvent(
      name: 'section_view',
      parameters: {'section_name': sectionName},
    );
  }
}
