import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      height: size.height - 80,
      constraints: const BoxConstraints(minHeight: 600),
      decoration: const BoxDecoration(color: AppTheme.primaryBg),
      child: Stack(
        children: [
          // Animated tech-connections background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return CustomPaint(
                  painter:
                      TechBackgroundPainter(progress: _bgController.value),
                );
              },
            ),
          ),

          // Glowing radial blob — top-right (cyan)
          Positioned(
            top: -200,
            right: -200,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentCyan.withValues(alpha: 0.08),
                    blurRadius: 120,
                    spreadRadius: 80,
                  ),
                ],
              ),
            ),
          ),

          // Glowing radial blob — bottom-left (gold)
          Positioned(
            bottom: -250,
            left: -200,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGold.withValues(alpha: 0.06),
                    blurRadius: 150,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),

          // Central content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // College tag pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentCyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: AppTheme.accentCyan.withValues(alpha: 0.3),
                          width: 1.5),
                    ),
                    child: Text(
                      'KLE SOCIETY\'S GANGAVATHI',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        color: AppTheme.accentCyan,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontSize: isMobile ? 12 : 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main title with gradient shader
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          AppTheme.accentGold,
                          Colors.white,
                          AppTheme.accentCyan,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'BCA FEST 2026',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: isMobile ? 48 : 96,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Celebrating Innovation and Technology',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 18 : 28,
                      color: AppTheme.textHeading,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date & location row
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 24,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              color: AppTheme.accentGold,
                              size: isMobile ? 16 : 20),
                          const SizedBox(width: 8),
                          Text(
                            'June 1, 2026',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: AppTheme.accentGold,
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 15 : 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_outlined,
                              color: AppTheme.accentCyan,
                              size: isMobile ? 16 : 20),
                          const SizedBox(width: 8),
                          Text(
                            'Gangavathi Campus',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: AppTheme.accentCyan,
                              fontWeight: FontWeight.w600,
                              fontSize: isMobile ? 15 : 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // CTA Button
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => context.go('/register'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        transform: Matrix4.diagonal3Values(
                          _isHovered ? 1.05 : 1.0,
                          _isHovered ? 1.05 : 1.0,
                          1.0,
                        ),
                        transformAlignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? AppTheme.accentCyan
                              : AppTheme.accentGold,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: (_isHovered
                                      ? AppTheme.accentCyan
                                      : AppTheme.accentGold)
                                  .withValues(alpha: 0.4),
                              blurRadius: _isHovered ? 30 : 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Register Now',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                color: _isHovered
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color:
                                  _isHovered ? Colors.white : Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Animated tech-nodes background painter
class TechBackgroundPainter extends CustomPainter {
  final double progress;
  TechBackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentCyan.withValues(alpha: 0.04)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppTheme.accentCyan.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final int nodeCount = (size.width > 768) ? 35 : 15;
    final List<math.Point<double>> nodes = [];

    for (int i = 0; i < nodeCount; i++) {
      double seedX = math.sin(i * 123.456 + progress * 0.1) * 0.5 + 0.5;
      double seedY = math.cos(i * 789.101 + progress * 0.05) * 0.5 + 0.5;
      nodes.add(math.Point(seedX * size.width, seedY * size.height));
    }

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        double dist = nodes[i].distanceTo(nodes[j]);
        if (dist < size.width * 0.18) {
          double alpha = (1.0 - (dist / (size.width * 0.18))) * 0.12;
          paint.color = AppTheme.accentCyan.withValues(alpha: alpha);
          canvas.drawLine(
            Offset(nodes[i].x, nodes[i].y),
            Offset(nodes[j].x, nodes[j].y),
            paint,
          );
        }
      }
    }

    for (var node in nodes) {
      canvas.drawCircle(Offset(node.x, node.y), 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TechBackgroundPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
