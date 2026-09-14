import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_widgets.dart';
import '../service/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = NotificationService();
  List<AppNotification> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await _service.fetchNotifications();
      if (mounted) setState(() { _items = items; _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load notifications: $e')),
        );
      }
    }
  }

  Future<void> _onTapItem(AppNotification item) async {
    if (!item.unread) return;
    setState(() {
      final idx = _items.indexWhere((n) => n.id == item.id);
      if (idx != -1) _items[idx] = item.copyWithRead(true);
    });
    try {
      await _service.markAsRead(item.id);
    } catch (_) {
      // silent — not critical if this fails, next full load will resync
    }
  }

  Future<void> _markAllRead() async {
    final hadUnread = _items.any((n) => n.unread);
    if (!hadUnread) return;
    setState(() {
      _items = _items.map((n) => n.copyWithRead(true)).toList();
    });
    try {
      await _service.markAllAsRead();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark all as read: $e')),
        );
      }
    }
  }

  ({IconData icon, Color bg, Color color}) _styleFor(String type) {
    switch (type) {
      case 'streak_milestone':
        return (icon: Icons.emoji_events_rounded, bg: const Color(0xFFEDEBFB), color: AppColors.purple);
      case 'task_completed':
        return (icon: Icons.check_rounded, bg: const Color(0xFFDDF4E3), color: const Color(0xFF3FA85B));
      case 'mood_check':
        return (icon: Icons.sentiment_satisfied_alt_rounded, bg: const Color(0xFFFFF0CF), color: const Color(0xFFE8A93B));
      case 'reminder':
        return (icon: Icons.calendar_today_rounded, bg: const Color(0xFFEDEBFB), color: AppColors.purple);
      case 'weekly_summary':
        return (icon: Icons.star_rounded, bg: const Color(0xFFEDEBFB), color: AppColors.purple);
      case 'friend_nudge':
        return (icon: Icons.favorite_rounded, bg: const Color(0xFFFCE4EC), color: const Color(0xFFE85878));
      default:
        return (icon: Icons.notifications_rounded, bg: const Color(0xFFEDEBFB), color: AppColors.purple);
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.purple, size: 26),
                ),
                GestureDetector(
                  onTap: _markAllRead,
                  child: Text(
                    'Mark all read',
                    style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.purple),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifications',
            style: GoogleFonts.nunito(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.ink),
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
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.purple))
                : _items.isEmpty
                ? Center(
              child: Text(
                'No notifications yet',
                style: GoogleFonts.nunito(color: AppColors.sub, fontWeight: FontWeight.w700),
              ),
            )
                : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.purple,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final item = _items[i];
                  final style = _styleFor(item.type);
                  return GestureDetector(
                    onTap: () => _onTapItem(item),
                    child: _NotificationCard(
                      icon: style.icon,
                      iconBg: style.bg,
                      iconColor: style.color,
                      title: item.title,
                      subtitle: item.body ?? '',
                      time: _timeAgo(item.createdAt),
                      unread: item.unread,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final bool unread;

  const _NotificationCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.unread,
  });

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
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.nunito(fontSize: 13.5, color: AppColors.sub)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.sub)),
              const SizedBox(height: 8),
              if (unread)
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