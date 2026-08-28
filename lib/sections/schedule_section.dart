import 'package:flutter/material.dart';
import '../theme.dart';

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    final events = [
      _ScheduleItem(
        time: '09:00 AM - 10:00 AM',
        title: 'Keynote & Inauguration',
        speaker: 'Dr. R. H. Sawkar',
        role: 'Principal & Tech Pioneer',
        desc: 'Opening statements and keynote on the evolution of cloud computing and developer ethics in 2026.',
        icon: Icons.rocket_launch,
        isCyan: false,
      ),
      _ScheduleItem(
        time: '10:15 AM - 12:15 PM',
        title: 'Coding Storm (Round 1 & 2)',
        speaker: 'Judge Panel (IIT & Industry Experts)',
        role: 'Evaluation Board',
        desc: 'Intense algorithmic and speed coding challenges testing logic, efficiency, and optimization skills.',
        icon: Icons.code,
        isCyan: true,
      ),
      _ScheduleItem(
        time: '12:30 PM - 01:30 PM',
        title: 'Networking & Lunch Hour',
        speaker: 'All Participants',
        role: 'Interactive Session',
        desc: 'Buffet lunch coupled with student project demos and interactions with regional tech recruiters.',
        icon: Icons.restaurant,
        isCyan: false,
      ),
      _ScheduleItem(
        time: '01:45 PM - 03:45 PM',
        title: 'Web Craft & Gaming Arena',
        speaker: 'Event Coordinators',
        role: 'Dual Event Tracks',
        desc: 'Designing responsive web pages on the spot under constraints, and LAN gaming finals.',
        icon: Icons.gamepad,
        isCyan: true,
      ),
      _ScheduleItem(
        time: '04:00 PM - 05:00 PM',
        title: 'Awards & Closing Ceremony',
        speaker: 'Chief Guest & HOD BCA',
        role: 'Valedictory Session',
        desc: 'Felicitation of winners, distribution of cash prizes, and closing address celebrating collaboration.',
        icon: Icons.emoji_events,
        isCyan: false,
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppTheme.primaryBg,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : size.width * 0.1,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section tag
          Text(
            '02. TIMELINE SCHEDULE',
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
            'Event Schedule',
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
          const SizedBox(height: 60),

          // Timeline layout
          isMobile
              ? _buildMobileTimeline(events)
              : _buildDesktopTimeline(events),
        ],
      ),
    );
  }

  // Simple card list for mobile devices
  Widget _buildMobileTimeline(List<_ScheduleItem> events) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return _ScheduleCard(item: events[index], isMobile: true);
      },
    );
  }

  // Timeline with vertical guide lines and alternating placements for desktop
  Widget _buildDesktopTimeline(List<_ScheduleItem> events) {
    return Stack(
      children: [
        // Center line
        Positioned(
          top: 0,
          bottom: 0,
          left: 50,
          child: Container(
            width: 3,
            color: AppTheme.textBody.withValues(alpha: 0.15),
          ),
        ),

        // Events
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final item = events[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Node circle
                  SizedBox(
                    width: 103,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: item.isCyan ? AppTheme.accentCyan : AppTheme.accentGold,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryBg,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (item.isCyan ? AppTheme.accentCyan : AppTheme.accentGold).withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Event content card
                  Expanded(
                    child: _ScheduleCard(item: item, isMobile: false),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ScheduleItem {
  final String time;
  final String title;
  final String speaker;
  final String role;
  final String desc;
  final IconData icon;
  final bool isCyan;

  _ScheduleItem({
    required this.time,
    required this.title,
    required this.speaker,
    required this.role,
    required this.desc,
    required this.icon,
    required this.isCyan,
  });
}

class _ScheduleCard extends StatefulWidget {
  final _ScheduleItem item;
  final bool isMobile;
  const _ScheduleCard({required this.item, required this.isMobile});

  @override
  State<_ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<_ScheduleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.item.isCyan ? AppTheme.accentCyan : AppTheme.accentGold;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(widget.isMobile ? 0.0 : (_isHovered ? 12.0 : 0.0), 0.0, 0.0),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppTheme.surfaceBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? themeColor : AppTheme.textBody.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.1),
              blurRadius: _isHovered ? 25 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left icon container
            if (!widget.isMobile) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.item.icon,
                  color: themeColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 24),
            ],

            // Content details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time & Category Tag
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.item.time,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Session title
                  Text(
                    widget.item.title,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: widget.isMobile ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textHeading,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Speaker info
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 16, color: AppTheme.accentGold.withValues(alpha: 0.8)),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.item.speaker} ',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppTheme.textHeading,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '(${widget.item.role})',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppTheme.textBody,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    widget.item.desc,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppTheme.textBody,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
