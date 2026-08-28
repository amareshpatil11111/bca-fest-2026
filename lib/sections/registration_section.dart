import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../theme.dart';

class RegistrationSection extends StatefulWidget {
  const RegistrationSection({super.key});

  @override
  State<RegistrationSection> createState() => _RegistrationSectionState();
}

class _RegistrationSectionState extends State<RegistrationSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    // Primary: save to Supabase database
    final success = await ApiService.registerParticipant(
      name: name,
      email: email,
      phone: phone,
    );

    // Secondary: also write to Firestore so the Cloud Function
    // (sendRegistrationEmail) triggers and sends confirmation emails
    if (success) {
      await FirebaseService.registerParticipant(
        name: name,
        email: email,
        phone: phone,
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (success) {
          _isSuccess = true;
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _formKey.currentState?.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Please try again.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      color: AppTheme.primaryBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : size.width * 0.1,
        vertical: 80,
      ),
      child: Center(
        child: Container(
          width: 650,
          decoration: AppTheme.glassCardDecoration(
            borderColor: _isSuccess ? AppTheme.accentGold.withValues(alpha: 0.4) : AppTheme.accentCyan.withValues(alpha: 0.2),
          ),
          padding: EdgeInsets.all(isMobile ? 24 : 48),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _isSuccess ? _buildSuccessCard() : _buildFormContent(isMobile),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(bool isMobile) {
    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('registration-form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Text
          Center(
            child: Column(
              children: [
                Text(
                  'REGISTRATION',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: AppTheme.accentGold,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Secure Your Spot',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textHeading,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register today to participate in national level events.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppTheme.textBody,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Name Input
          const Text(
            'Full Name',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.textHeading,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
            decoration: const InputDecoration(
              hintText: 'Enter your full name',
              prefixIcon: Icon(Icons.person_outline, color: AppTheme.textBody),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Email Input
          const Text(
            'Email Address',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.textHeading,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
            decoration: const InputDecoration(
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.alternate_email_outlined, color: AppTheme.textBody),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Phone Input
          const Text(
            'Phone Number',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppTheme.textHeading,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
            decoration: const InputDecoration(
              hintText: 'Enter your 10-digit mobile number',
              prefixIcon: Icon(Icons.phone_android_outlined, color: AppTheme.textBody),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              final phoneRegex = RegExp(r'^\d{10}$');
              if (!phoneRegex.hasMatch(value.trim())) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
            onFieldSubmitted: (_) => _submitForm(),
          ),
          const SizedBox(height: 36),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentCyan,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Complete Registration',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Column(
      key: const ValueKey('success-state'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Success checkmark animation container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.accentGold, width: 2),
          ),
          child: const Center(
            child: Icon(
              Icons.check_circle_outline,
              color: AppTheme.accentGold,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Registration Successful!',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textHeading,
          ),
        ),
        const SizedBox(height: 12),
        
        Text(
          'Thank you for registering for BCA Fest 2026. We are excited to have you join us at KLE BCA College, Gangavathi!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme.textBody,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          'A confirmation email has been triggered and will be sent to your registered address shortly.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme.accentCyan,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 36),

        // Register Another Participant
        OutlinedButton(
          onPressed: () {
            setState(() {
              _isSuccess = false;
              _nameController.clear();
              _emailController.clear();
              _phoneController.clear();
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.accentCyan,
            side: const BorderSide(color: AppTheme.accentCyan, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Register Another Participant',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
