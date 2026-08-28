import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  Timer? _carouselTimer;
  bool _isHovered = false;

  final List<_GalleryImage> _images = [
    _GalleryImage(
      url: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1200&q=80',
      title: 'Coding Marathon 2025',
      desc: 'Coding Teams burning the midnight oil to build innovative logic solutions.',
    ),
    _GalleryImage(
      url: 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=1200&q=80',
      title: 'UI/UX Design Showcase',
      desc: 'Presenting beautiful, interactive mockups and production-ready web designs.',
    ),
    _GalleryImage(
      url: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=1200&q=80',
      title: 'Lan Gaming Championship',
      desc: 'Intense tactical matches in our annual esports arenas.',
    ),
    _GalleryImage(
      url: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=1200&q=80',
      title: 'Valedictory & Awards',
      desc: 'Celebrating achievements, hard work, and sharing our vision for the future.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_isHovered) return;
      
      int next = _currentPage + 1;
      if (next >= _images.length) next = 0;
      
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      color: AppTheme.surfaceBg,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header aligned to match others
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : size.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '04. PAST MEMORIES',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: AppTheme.accentCyan,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Glimpses of Past Events',
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
                    color: AppTheme.accentGold,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),

          // Interactive Carousel Wrapper
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: SizedBox(
              height: isMobile ? 350 : 500,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // PageView Slider
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _images.length,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _images[index];
                      final isSelected = index == _currentPage;

                      return AnimatedScale(
                        scale: isSelected ? 1.0 : 0.93,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.4,
                          duration: const Duration(milliseconds: 500),
                          child: _buildGalleryCard(item, isMobile),
                        ),
                      );
                    },
                  ),

                  // Left control arrow (desktop only)
                  if (!isMobile)
                    Positioned(
                      left: size.width * 0.05,
                      child: _buildNavigationButton(
                        icon: Icons.chevron_left,
                        onPressed: () {
                          int prev = _currentPage - 1;
                          if (prev < 0) prev = _images.length - 1;
                          _pageController.animateToPage(
                            prev,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                      ),
                    ),

                  // Right control arrow (desktop only)
                  if (!isMobile)
                    Positioned(
                      right: size.width * 0.05,
                      child: _buildNavigationButton(
                        icon: Icons.chevron_right,
                        onPressed: () {
                          int next = _currentPage + 1;
                          if (next >= _images.length) next = 0;
                          _pageController.animateToPage(
                            next,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutCubic,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Custom Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_images.length, (index) {
              final isSelected = index == _currentPage;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: isSelected ? 32 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accentCyan : AppTheme.textBody.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard(_GalleryImage image, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Image
          Positioned.fill(
            child: Image.network(
              image.url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppTheme.primaryBg,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentCyan,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.surfaceBg,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: AppTheme.textBody, size: 48),
                  ),
                );
              },
            ),
          ),

          // Gradient overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.01),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Caption Text
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 36),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  image.title,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: isMobile ? 20 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  image.desc,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 13 : 15,
                    color: AppTheme.textHeading.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ), // Padding
          ), // Positioned
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBg.withValues(alpha: 0.8),
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.3), width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppTheme.accentCyan),
        iconSize: 32,
        onPressed: onPressed,
      ),
    );
  }
}

class _GalleryImage {
  final String url;
  final String title;
  final String desc;

  _GalleryImage({
    required this.url,
    required this.title,
    required this.desc,
  });
}
