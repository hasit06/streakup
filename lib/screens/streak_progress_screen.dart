import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_widgets.dart';

class StreakProgressScreen extends StatefulWidget {
  const StreakProgressScreen({super.key});

  @override
  State<StreakProgressScreen> createState() => _StreakProgressScreenState();
}

class _StreakProgressScreenState extends State<StreakProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 16),
              _buildProfileXpRow(),
              const SizedBox(height: 16),
              _streakBannerRow(),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Streak Overview',
                child: _statsRow([
                  _StatItem(Icons.local_fire_department_rounded, AppColorsSP.purple, '67', 'Current Streak'),
                  _StatItem(Icons.emoji_events_rounded, const Color(0xFF3E9AE8), '92', 'Longest Streak'),
                  _StatItem(Icons.event_available_rounded, const Color(0xFFE85878), '86%', 'Success Rate'),
                  _StatItem(Icons.check_circle_rounded, const Color(0xFF4CAF7D), '18', 'Days This Month'),
                  _StatItem(Icons.star_rounded, const Color(0xFFB48CEA), '6700+', 'Total XP'),
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
                      time: 'Aug 05, 2026',
                      xp: '+50 Xp',
                    ),
                    _ActivityTile(
                      icon: Icons.eco_rounded,
                      iconColor: Color(0xFF4CAF7D),
                      title: 'Freeze Used',
                      subtitle: 'Streak protected',
                      time: 'Aug 05, 2026',
                      xp: '0 Xp',
                    ),
                    _ActivityTile(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: Color(0xFF6C5CE7),
                      title: 'Streak Milestone',
                      subtitle: '🔥 10-day streak achieved!',
                      time: 'Aug 02, 2026',
                      xp: '+200 Xp',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- TOP BAR ----------
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_rounded, color: AppColorsSP.purple, size: 26),
        ),
        const SizedBox(width: 14),
        Text(
          'Personal Progress',
          style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w900, color: AppColorsSP.ink),
        ),
      ],
    );
  }

  // ---------- PROFILE + XP ROW ----------
  Widget _buildProfileXpRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 56,
              height: 56,
              color: AppColorsSP.purple.withOpacity(0.1),
              child: Image.asset(
                'assets/avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded, color: AppColorsSP.purple, size: 30),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hasit', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
                Text(
                  'Small steps. Big progress. 💜',
                  style: GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFFF1EFFF), borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events_rounded, color: AppColorsSP.purple, size: 20),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('6700+ Xp', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
                    Text('Total XP', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
                  ],
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: AppColorsSP.sub, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- STREAK BANNER + GOAL (side by side cards) ----------
  Widget _streakBannerRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(color: Color(0xFFEDEBFB), shape: BoxShape.circle),
                    child: const Icon(Icons.local_fire_department_rounded, color: AppColorsSP.purple, size: 24),
                  ),
                  const SizedBox(height: 10),
                  Text('67', style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
                  Text('day streak!', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColorsSP.ink)),
                  const SizedBox(height: 4),
                  Text('Keep it going! 🔥', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
              child: _goalCard('Reach a 90-day streak', '23 days to go', 67 / 90),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalCard(String title, String subtitle, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(color: Color(0xFFEDEBFB), shape: BoxShape.circle),
          child: const Icon(Icons.track_changes_rounded, color: AppColorsSP.purple, size: 18),
        ),
        const SizedBox(height: 10),
        Text(title, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColorsSP.ink)),
        const SizedBox(height: 2),
        Text(subtitle, style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 7,
            backgroundColor: const Color(0xFFE2DDFE),
            valueColor: const AlwaysStoppedAnimation(AppColorsSP.purple),
          ),
        ),
      ],
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
              Text(s.value, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w900, color: AppColorsSP.ink)),
              const SizedBox(height: 2),
              Text(s.label, textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
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
  final String xp;

  const _ActivityTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.xp,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(xp, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w800, color: AppColorsSP.purple)),
              Text(time, style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700, color: AppColorsSP.sub)),
            ],
          ),
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