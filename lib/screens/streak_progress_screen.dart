import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_widgets.dart';

class StreakProgressScreen extends StatefulWidget {
  const StreakProgressScreen({super.key});

  @override
  State<StreakProgressScreen> createState() => _StreakProgressScreenState();
}

class _StreakProgressScreenState extends State<StreakProgressScreen> {
  bool _isGroup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              child: Column(
                children: _isGroup ? _buildGroupSections() : _buildPersonalSections(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- HEADER ----------
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5B7CFA), Color(0xFF6C5CE7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
              ),
              Text(
                'Streak Progress',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const Icon(Icons.share_rounded, color: Colors.white, size: 22),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                _segmentBtn('PERSONAL', !_isGroup, () => setState(() => _isGroup = false)),
                _segmentBtn('GROUP', _isGroup, () => setState(() => _isGroup = true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: active
                ? const Border(bottom: BorderSide(color: Color(0xFF6C5CE7), width: 2.5))
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: active ? const Color(0xFF6C5CE7) : const Color(0xFF8B8C9E),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- PERSONAL ----------
  List<Widget> _buildPersonalSections() {
    return [
      const SizedBox(height: 16),
      _streakBannerCard(
        iconBg: const Color(0xFF6C5CE7),
        icon: Icons.local_fire_department_rounded,
        count: '12',
        title: 'day streak!',
        subtitle: 'Keep it going! 🔥',
        goalTitle: 'Reach a 30-day streak',
        goalSubtitle: '18 days to go',
        progress: 12 / 30,
      ),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Streak Overview',
        child: _statsRow([
          _StatItem(Icons.local_fire_department_rounded, AppColorsSP.purple, '12', 'Current Streak'),
          _StatItem(Icons.emoji_events_rounded, const Color(0xFF3E9AE8), '28', 'Longest Streak'),
          _StatItem(Icons.event_available_rounded, const Color(0xFFE85878), '85%', 'Success Rate'),
          _StatItem(Icons.check_circle_rounded, const Color(0xFF4CAF7D), '10', 'Days This Month'),
        ]),
      ),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Streak Calendar',
        child: const MonthlyStreakCalendar(),
      ),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Streak Activity',
        trailing: _viewAllLink(),
        child: Column(
          children: const [
            _ActivityTile(
              icon: Icons.access_time_filled_rounded,
              iconColor: Color(0xFFB0285A),
              title: 'Task Completed',
              subtitle: 'Design daily UI challenge',
              time: 'Today, 07:30 AM',
            ),
            _ActivityTile(
              icon: Icons.eco_rounded,
              iconColor: Color(0xFF4CAF7D),
              title: 'Freeze Used',
              subtitle: 'Streak protected',
              time: 'Aug 05, 2026',
            ),
            _ActivityTile(
              icon: Icons.local_fire_department_rounded,
              iconColor: Color(0xFF6C5CE7),
              title: 'Streak Milestone',
              subtitle: '🔥 10-day streak achieved!',
              time: 'Aug 02, 2026',
            ),
          ],
        ),
      ),
    ];
  }

  // ---------- GROUP ----------
  List<Widget> _buildGroupSections() {
    final members = [
      ('You', 18, true),
      ('Aarav', 16, false),
      ('Diya', 15, false),
      ('Rohan', 14, false),
      ('Ishita', 12, false),
      ('Kabir', 10, false),
    ];

    return [
      const SizedBox(height: 16),
      _groupStreakBanner(),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Group Overview',
        child: _statsRow([
          _StatItem(Icons.local_fire_department_rounded, AppColorsSP.purple, '18', 'Current Streak'),
          _StatItem(Icons.emoji_events_rounded, const Color(0xFF3E9AE8), '27', 'Longest Streak'),
          _StatItem(Icons.event_available_rounded, const Color(0xFFE85878), '82%', 'Success Rate'),
          _StatItem(Icons.check_circle_rounded, const Color(0xFF4CAF7D), '8/10', 'Active Members'),
        ]),
      ),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Group Members (8/10 active)',
        trailing: _viewAllLink(),
        child: SizedBox(
          height: 86,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: members.length + 1,
            itemBuilder: (context, index) {
              if (index == members.length) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(color: Color(0xFFF1EFFF), shape: BoxShape.circle),
                        child: Center(
                          child: Text('+2', style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColorsSP.purple)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('More', style: GoogleFonts.nunito(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
                    ],
                  ),
                );
              }
              final (name, streak, isYou) = members[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isYou ? Border.all(color: AppColorsSP.purple, width: 2.5) : null,
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFEDEBFB),
                        child: Text(name[0], style: GoogleFonts.nunito(fontWeight: FontWeight.w800, color: AppColorsSP.purple)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(isYou ? 'You' : name, style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w800, color: AppColorsSP.ink)),
                    Text('${streak}d', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700, color: AppColorsSP.purple)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Group Streak Calendar',
        child: const MonthlyStreakCalendar(),
      ),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Recent Group Activity',
        trailing: _viewAllLink(),
        child: Column(
          children: const [
            _ActivityTile(
              icon: Icons.event_available_rounded,
              iconColor: Color(0xFFB0285A),
              title: 'Diya completed "Read 20 pages"',
              subtitle: '+1 day to group streak',
              time: 'Today, 07:30 AM',
            ),
            _ActivityTile(
              icon: Icons.eco_rounded,
              iconColor: Color(0xFF4CAF7D),
              title: 'Kabir used a freeze',
              subtitle: 'Streak protected',
              time: 'Yesterday, 09:15 PM',
            ),
            _ActivityTile(
              icon: Icons.local_fire_department_rounded,
              iconColor: Color(0xFF6C5CE7),
              title: 'Group milestone achieved!',
              subtitle: '15-day group streak! 🎉',
              time: 'Aug 05, 2026',
            ),
            _ActivityTile(
              icon: Icons.groups_rounded,
              iconColor: Color(0xFF3E9AE8),
              title: 'Aarav joined the group',
              subtitle: 'Welcome aboard! 🚀',
              time: 'Aug 02, 2026',
            ),
          ],
        ),
      ),
    ];
  }

  // ---------- SHARED PIECES ----------
  Widget _streakBannerCard({
    required Color iconBg,
    required IconData icon,
    required String count,
    required String title,
    required String subtitle,
    required String goalTitle,
    required String goalSubtitle,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(count, style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
                      Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColorsSP.ink)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(subtitle, style: GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(child: _goalCard(goalTitle, goalSubtitle, progress)),
        ],
      ),
    );
  }

  Widget _groupStreakBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(color: AppColorsSP.purple, shape: BoxShape.circle),
                    child: const Icon(Icons.groups_rounded, color: Colors.white, size: 26),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Color(0xFFFFA726), shape: BoxShape.circle),
                      child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('18', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
                    Text('day group streak!', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColorsSP.ink)),
                  ],
                ),
              ),
              Expanded(child: _goalCard('Reach a 30-day group streak', '12 days to go', 18 / 30)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Your group is on fire! 🔥', style: GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
        ],
      ),
    );
  }

  Widget _goalCard(String title, String subtitle, double progress) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF6F5FF), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(color: Color(0xFFEDEBFB), shape: BoxShape.circle),
            child: const Icon(Icons.track_changes_rounded, color: AppColorsSP.purple, size: 16),
          ),
          const SizedBox(height: 6),
          Text(title, style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColorsSP.ink)),
          Text(subtitle, style: GoogleFonts.nunito(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 6,
              backgroundColor: const Color(0xFFE2DDFE),
              valueColor: const AlwaysStoppedAnimation(AppColorsSP.purple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, Widget? trailing, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _viewAllLink() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('View All', style: GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColorsSP.purple)),
        const Icon(Icons.chevron_right_rounded, color: AppColorsSP.purple, size: 18),
      ],
    );
  }

  Widget _statsRow(List<_StatItem> items) {
    return Row(
      children: items.map((s) {
        return Expanded(
          child: Column(
            children: [
              Icon(s.icon, color: s.color, size: 22),
              const SizedBox(height: 8),
              Text(s.value, style: GoogleFonts.nunito(fontSize: 17, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
              const SizedBox(height: 2),
              Text(s.label, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  _StatItem(this.icon, this.color, this.value, this.label);
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  const _ActivityTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColorsSP.ink)),
                Text(subtitle, style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColorsSP.sub)),
              ],
            ),
          ),
          Text(time, style: GoogleFonts.nunito(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
        ],
      ),
    );
  }
}

class AppColorsSP {
  static const purple = Color(0xFF6C5CE7);
  static const ink = Color(0xFF1E1C3B);
  static const sub = Color(0xFF8B8C9E);
}