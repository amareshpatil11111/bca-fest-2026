import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;
import '../theme.dart';

class VenueSection extends StatefulWidget {
  const VenueSection({super.key});

  @override
  State<VenueSection> createState() => _VenueSectionState();
}

class _VenueSectionState extends State<VenueSection> {
  bool _addressHovered = false;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    // Register Google Maps iframe for Flutter Web
    ui_web.platformViewRegistry.registerViewFactory(
      'google-maps-iframe',
      (int viewId) {
        final iframe = web.HTMLIFrameElement()
          ..src = "https://maps.google.com/maps?q=K.L.E.+Society's+B.C.A.+College+Gangavathi&t=&z=16&ie=UTF8&iwloc=&output=embed"
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return iframe;
      },
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 992;
    const String collegeAddress = "KLE Society's B.C.A. College, CBS Gunj Road, Gangavathi - 583227, Karnataka, India";

    return Container(
      width: double.infinity,
      color: AppTheme.surfaceBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : size.width * 0.1,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section tag & Title
          Text(
            '03. THE VENUE',
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
            'Location & Details',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.w800,
              color: AppTheme.textHeading,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.accentCyan,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 50),

          // Layout Split: Map & Details
          isMobile
              ? Column(
                  children: [
                    _buildDetailsCard(collegeAddress),
                    const SizedBox(height: 32),
                    _buildMapWidget(500),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildDetailsCard(collegeAddress),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      flex: 6,
                      child: _buildMapWidget(450),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KLE Society\'s BCA College',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentCyan,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gangavathi Campus',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppTheme.textBody,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),

        // Address clickable block
        MouseRegion(
          onEnter: (_) => setState(() => _addressHovered = true),
          onExit: (_) => setState(() => _addressHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _copyToClipboard(address),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _addressHovered ? AppTheme.accentGold : AppTheme.textBody.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: AppTheme.accentGold, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppTheme.textHeading,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          address,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: AppTheme.textBody,
                            height: 1.5,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _copied ? 'Address Copied!' : 'Click to copy address',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            color: _copied ? AppTheme.accentCyan : AppTheme.textBody.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Phone & Email contact details
        _buildContactRow(
          icon: Icons.phone_android_outlined,
          title: 'Phone Contact',
          value: '+91 80957 78378',
        ),
        const SizedBox(height: 16),
        _buildContactRow(
          icon: Icons.alternate_email_outlined,
          title: 'Official Email',
          value: 'bca.gvti@gmail.com',
        ),
      ],
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentCyan, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  color: AppTheme.textBody,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: AppTheme.textHeading,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapWidget(double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.primaryBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentCyan.withValues(alpha: 0.05),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: const HtmlElementView(
        viewType: 'google-maps-iframe',
      ),
    );
  }
}
