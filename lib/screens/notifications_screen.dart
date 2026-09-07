import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_widgets.dart';

class NotificationItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;

  const NotificationItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.unread = true,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static final List<NotificationItem> _items = [
    NotificationItem(
      icon: Icons.emoji_events_rounded,
      iconBg: const Color(0xFFEDEBFB),
      iconColor: AppColors.purple,
      title: 'Streak Milestone! 🔥',
      subtitle: "You've reached a 67 day streak!",
      time: '2m ago',
    ),
    NotificationItem(
      icon: Icons.check_rounded,
      iconBg: const Color(0xFFDDF4E3),
      iconColor: const Color(0xFF3FA85B),
      title: 'Task Completed',
      subtitle: 'Great job! You completed "Data Structures"',
      time: '1h ago',
    ),
    NotificationItem(
      icon: Icons.sentiment_satisfied_alt_rounded,
      iconBg: const Color(0xFFFFF0CF),
      iconColor: const Color(0xFFE8A93B),
      title: 'Mood Check',
      subtitle: 'How are you feeling today?',
      time: '8h ago',
    ),
    NotificationItem(
      icon: Icons.calendar_today_rounded,
      iconBg: const Color(0xFFEDEBFB),
      iconColor: AppColors.purple,
      title: 'Daily Reminder',
      subtitle: "Don't forget to complete your tasks!",
      time: '1d ago',
    ),
    NotificationItem(
      icon: Icons.star_rounded,
      iconBg: const Color(0xFFEDEBFB),
      iconColor: AppColors.purple,
      title: 'Weekly Summary',
      subtitle: 'You completed 5 out of 7 tasks this week!',
      time: '2d ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.purple, size: 26),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifications',
            style: GoogleFonts.nunito(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Stay updated with what's happening ",
                style: GoogleFonts.nunito(fontSize: 14, color: AppColors.sub),
              ),
              const Icon(Icons.notifications_rounded, size: 18, color: AppColors.purple),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) => _NotificationCard(item: _items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: softCard(radius: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: GoogleFonts.nunito(fontSize: 13.5, color: AppColors.sub),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.time,
                style: GoogleFonts.nunito(fontSize: 12, color: AppColors.sub),
              ),
              const SizedBox(height: 8),
              if (item.unread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.purple, shape: BoxShape.circle),
                ),
            ],
          ),
        ],
      ),
    );
  }
}