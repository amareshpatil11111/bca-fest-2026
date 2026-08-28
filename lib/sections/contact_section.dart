import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      color: AppTheme.primaryBg,
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      child: Column(
        children: [
          // Section header info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : size.width * 0.1),
            child: Column(
              children: [
                Text(
                  'GET IN TOUCH',
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
                  'Join the Conversation',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textHeading,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Have questions? Follow us on social media or reach out directly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: AppTheme.textBody,
                  ),
                ),
                const SizedBox(height: 40),

                // Social Links row
                Wrap(
                  spacing: 24,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSocialButton(
                      icon: FontAwesomeIcons.xTwitter,
                      label: 'Twitter',
                      onTap: () => _launchUrl('https://x.com'),
                      hoverColor: Colors.lightBlueAccent,
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.linkedin,
                      label: 'LinkedIn',
                      onTap: () => _launchUrl('https://linkedin.com'),
                      hoverColor: Colors.blueAccent,
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.github,
                      label: 'GitHub',
                      onTap: () => _launchUrl('https://github.com'),
                      hoverColor: Colors.white,
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.instagram,
                      label: 'Instagram',
                      onTap: () => _launchUrl('https://instagram.com'),
                      hoverColor: Colors.pinkAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 80),

                // Divider line
                Container(
                  width: double.infinity,
                  height: 1.5,
                  color: AppTheme.textBody.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 40),

                // Footer section details
                isMobile
                    ? Column(
                        children: [
                          _buildFooterLeft(),
                          const SizedBox(height: 24),
                          _buildFooterRight(),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFooterLeft(),
                          _buildFooterRight(),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLeft() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '© 2026 KLE Society\'s B.C.A. College, Gangavathi.',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            color: AppTheme.textHeading,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Celebrating Innovation and Technology. All rights reserved.',
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme.textBody,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterRight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFooterLink('Privacy Policy'),
        const SizedBox(width: 20),
        _buildFooterLink('Terms of Service'),
        const SizedBox(width: 20),
        _buildFooterLink('Contact Us'),
      ],
    );
  }

  Widget _buildFooterLink(String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 13,
          color: AppTheme.textBody,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
    required Color hoverColor,
  }) {
    return _SocialButton(
      icon: icon,
      label: label,
      onTap: onTap,
      hoverColor: hoverColor,
    );
  }
}

class _SocialButton extends StatefulWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onTap;
  final Color hoverColor;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.hoverColor,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered ? widget.hoverColor.withValues(alpha: 0.1) : AppTheme.surfaceBg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: _isHovered ? widget.hoverColor : AppTheme.textBody.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon as dynamic,
                color: _isHovered ? widget.hoverColor : AppTheme.textHeading,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: _isHovered ? widget.hoverColor : AppTheme.textHeading,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
