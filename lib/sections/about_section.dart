import 'package:flutter/material.dart';
import '../theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

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
          // Section Tag & Header
          Text(
            '01. ABOUT THE FEST',
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
            'Where Passion Meets Technology',
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
          const SizedBox(height: 40),

          // Layout Split: Info Text & Tech Features
          isMobile
              ? Column(
                  children: [
                    _buildInfoText(),
                    const SizedBox(height: 48),
                    _buildHighlightsGrid(true),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildInfoText(),
                    ),
                    const SizedBox(width: 80),
                    Expanded(
                      flex: 5,
                      child: _buildHighlightsGrid(false),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildInfoText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BCA Fest 2026 is the annual flagship technical festival organized by the Department of Computer Applications at KLE BCA College, Gangavathi.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            color: AppTheme.textHeading,
            fontWeight: FontWeight.w500,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Our mission is to foster innovation, push creative boundaries, and provide a competitive yet collaborative arena for students to showcase their expertise. We bring together developers, designers, and tech enthusiasts from across the region to network, learn, and excel.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppTheme.textBody,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'From intense coding marathons to strategic web design and insightful tech presentations, there is a challenge tailored for every innovator.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: AppTheme.textBody,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildHighlightsGrid(bool isMobile) {
    final highlights = [
      _HighlightData(
        icon: Icons.code_rounded,
        title: 'Coding Storm',
        desc: 'Solve complex algorithmic and logical problems to prove your programming superiority.',
      ),
      _HighlightData(
        icon: Icons.web_rounded,
        title: 'Web Crafting',
        desc: 'Build functional, gorgeous, and highly responsive web applications from scratch.',
      ),
      _HighlightData(
        icon: Icons.gamepad_rounded,
        title: 'Gaming Arena',
        desc: 'Showcase tactical skills, lightning reflexes, and team synergy in intense multiplayer battles.',
      ),
      _HighlightData(
        icon: Icons.lightbulb_rounded,
        title: 'Innovate Presentation',
        desc: 'Present original ideas and research papers on AI, Machine Learning, and Cloud Computing.',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.3,
      ),
      itemCount: highlights.length,
      itemBuilder: (context, index) {
        return _AboutCard(data: highlights[index]);
      },
    );
  }
}

class _HighlightData {
  final IconData icon;
  final String title;
  final String desc;

  _HighlightData({
    required this.icon,
    required this.title,
    required this.desc,
  });
}

class _AboutCard extends StatefulWidget {
  final _HighlightData data;
  const _AboutCard({required this.data});

  @override
  State<_AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<_AboutCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(0.0, _isHovered ? -8.0 : 0.0, 0.0),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.primaryBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? AppTheme.accentCyan : AppTheme.textBody.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? AppTheme.accentCyan.withValues(alpha: 0.15) 
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: _isHovered ? 20 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isHovered 
                    ? AppTheme.accentCyan.withValues(alpha: 0.15) 
                    : AppTheme.surfaceBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.data.icon,
                color: _isHovered ? AppTheme.accentCyan : AppTheme.accentGold,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.data.title,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textHeading,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                widget.data.desc,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppTheme.textBody,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
