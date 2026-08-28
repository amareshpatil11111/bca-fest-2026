import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'services/firebase_service.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/schedule_section.dart';
import 'sections/venue_section.dart';
import 'sections/registration_section.dart';
import 'sections/gallery_section.dart';
import 'sections/contact_section.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (falls back to mock if not configured)
  await FirebaseService.initialize();
  
  runApp(const BcaFestApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const BcaFestHomeScreen(section: 'hero'),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const BcaFestHomeScreen(section: 'about'),
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => const BcaFestHomeScreen(section: 'schedule'),
    ),
    GoRoute(
      path: '/venue',
      builder: (context, state) => const BcaFestHomeScreen(section: 'venue'),
    ),
    GoRoute(
      path: '/gallery',
      builder: (context, state) => const BcaFestHomeScreen(section: 'gallery'),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const BcaFestHomeScreen(section: 'register'),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const BcaFestHomeScreen(section: 'contact'),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppTheme.primaryBg,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '404',
            style: TextStyle(
              fontSize: 80,
              fontFamily: 'Outfit',
              color: AppTheme.accentGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Page Not Found',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Inter',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.go('/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentCyan,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);

class BcaFestApp extends StatelessWidget {
  const BcaFestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BCA Fest 2026',
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class BcaFestHomeScreen extends StatefulWidget {
  final String section;
  const BcaFestHomeScreen({super.key, required this.section});

  @override
  State<BcaFestHomeScreen> createState() => _BcaFestHomeScreenState();
}

class _BcaFestHomeScreenState extends State<BcaFestHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Section keys for scrolling
  final GlobalKey _heroKey = GlobalKey(debugLabel: 'hero');
  final GlobalKey _aboutKey = GlobalKey(debugLabel: 'about');
  final GlobalKey _scheduleKey = GlobalKey(debugLabel: 'schedule');
  final GlobalKey _venueKey = GlobalKey(debugLabel: 'venue');
  final GlobalKey _galleryKey = GlobalKey(debugLabel: 'gallery');
  final GlobalKey _registerKey = GlobalKey(debugLabel: 'register');
  final GlobalKey _contactKey = GlobalKey(debugLabel: 'contact');

  late Map<String, GlobalKey> _sectionKeys;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _sectionKeys = {
      'hero': _heroKey,
      'about': _aboutKey,
      'schedule': _scheduleKey,
      'venue': _venueKey,
      'gallery': _galleryKey,
      'register': _registerKey,
      'contact': _contactKey,
    };

    _scrollController.addListener(_scrollListener);

    // Initial scroll after build frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSection(widget.section);
    });
  }

  @override
  void didUpdateWidget(covariant BcaFestHomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.section != widget.section) {
      _scrollToSection(widget.section);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  void _scrollToSection(String sectionName) {
    final key = _sectionKeys[sectionName];
    if (key != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = key.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 750),
            curve: Curves.easeInOutCubic,
          );
          // Log view
          FirebaseService.logSectionView(sectionName);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 992;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(size.width, 80),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: _isScrolled ? AppTheme.primaryBg.withValues(alpha: 0.95) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: _isScrolled ? AppTheme.textBody.withValues(alpha: 0.1) : Colors.transparent,
                width: 1.5,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo/Brand Name
              GestureDetector(
                onTap: () => context.go('/'),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.school, color: AppTheme.accentGold, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'KLE BCA',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nav Items / Hamburger
              if (isMobile)
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                )
              else
                Row(
                  children: [
                    _buildNavLink('About', '/about'),
                    _buildNavLink('Schedule', '/schedule'),
                    _buildNavLink('Venue', '/venue'),
                    _buildNavLink('Gallery', '/gallery'),
                    _buildNavLink('Contact', '/contact'),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => context.go('/register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      endDrawer: isMobile ? _buildMobileDrawer() : null,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(key: _heroKey),
            AboutSection(key: _aboutKey),
            ScheduleSection(key: _scheduleKey),
            VenueSection(key: _venueKey),
            GallerySection(key: _galleryKey),
            RegistrationSection(key: _registerKey),
            ContactSection(key: _contactKey),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(String title, String path) {
    final currentPath = GoRouterState.of(context).uri.path;
    final isSelected = currentPath == path;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () => context.go(path),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: isSelected ? AppTheme.accentCyan : AppTheme.textHeading,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 16 : 0,
                height: 2,
                color: AppTheme.accentCyan,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: AppTheme.primaryBg,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'NAVIGATION',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGold,
                    letterSpacing: 1.5,
                  ),
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildDrawerLink('Home', '/'),
            _buildDrawerLink('About the Fest', '/about'),
            _buildDrawerLink('Schedule', '/schedule'),
            _buildDrawerLink('Venue Location', '/venue'),
            _buildDrawerLink('Past Memories', '/gallery'),
            _buildDrawerLink('Get in Touch', '/contact'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/register');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentCyan,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Register Now',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerLink(String title, String path) {
    final isSelected = GoRouterState.of(context).uri.path == path;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
          context.go(path);
        },
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 20,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppTheme.accentCyan : AppTheme.textHeading,
          ),
        ),
      ),
    );
  }
}
