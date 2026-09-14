import 'package:supabase_flutter/supabase_flutter.dart';

class AppNotification {
  final String id;
  final String title;
  final String? body;
  final String type;
  final bool read;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  // Add these inside the AppNotification class, alongside the existing fields:
  bool get unread => !read;

  AppNotification copyWithRead(bool newRead) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      read: newRead,
      createdAt: createdAt,
    );
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String?,
      type: map['type'] as String? ?? 'general',
      read: map['read'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class NotificationService {
  final _supabase = Supabase.instance.client;

  Future<List<AppNotification>> fetchNotifications() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final rows = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (rows as List).map((r) => AppNotification.fromMap(r)).toList();
  }

  Future<int> fetchUnreadCount() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return 0;

    final resp = await _supabase
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('read', false)
        .count(CountOption.exact);

    return resp.count;
  }

  Future<void> markAsRead(String id) async {
    await _supabase.from('notifications').update({'read': true}).eq('id', id);
  }

  Future<void> markAllAsRead() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    await _supabase.from('notifications').update({'read': true}).eq('user_id', userId).eq('read', false);
  }
}