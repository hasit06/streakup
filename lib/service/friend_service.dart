import 'package:supabase_flutter/supabase_flutter.dart';
import 'streak_service.dart';

class Friend {
  final String id; // friends table row id
  final String userId; // the friend's actual auth id
  final String fullName;
  final String? avatarPath;

  Friend({required this.id, required this.userId, required this.fullName, this.avatarPath});
}

class FriendService {
  final _supabase = Supabase.instance.client;
  Future<Map<String, dynamic>?> findUserByFriendCode(String code) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final row = await _supabase
        .from('profiles')
        .select('id, full_name, username, friend_code')
        .eq('friend_code', code.trim().toUpperCase())
        .neq('id', userId)
        .maybeSingle();

    return row;
  }

  Future<String?> fetchMyFriendCode() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final row = await _supabase.from('profiles').select('friend_code').eq('id', userId).maybeSingle();
    return row?['friend_code'] as String?;
  }

  Future<void> sendFriendRequest(String receiverId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('friend_requests').insert({
      'sender_id': userId,
      'receiver_id': receiverId,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> fetchIncomingRequests() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final rows = await _supabase
        .from('friend_requests')
        .select('id, sender_id, profiles!friend_requests_sender_profile_fkey(full_name, username, avatar_path)')
        .eq('receiver_id', userId)
        .eq('status', 'pending');

    return (rows as List).cast<Map<String, dynamic>>();
  }

  Future<void> acceptRequest(String requestId, String senderId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('friend_requests').update({'status': 'accepted'}).eq('id', requestId);

    // Create the friendship both directions so each side sees the other in their list
    await _supabase.from('friends').upsert([
      {'user_id': userId, 'friend_id': senderId},
      {'user_id': senderId, 'friend_id': userId},
    ]);
  }

  Future<void> declineRequest(String requestId) async {
    await _supabase.from('friend_requests').update({'status': 'declined'}).eq('id', requestId);
  }

  Future<List<Friend>> fetchFriends() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final rows = await _supabase
        .from('friends')
        .select('id, friend_id, profiles!friends_friend_profile_fkey(full_name, avatar_path)')
        .eq('user_id', userId);

    return (rows as List).map((r) {
      final profile = r['profiles'] as Map<String, dynamic>?;
      return Friend(
        id: r['id'] as String,
        userId: r['friend_id'] as String,
        fullName: (profile?['full_name'] as String?) ?? 'Unknown',
        avatarPath: profile?['avatar_path'] as String?,
      );
    }).toList();
  }

  Future<void> removeFriend(String friendsRowId) async {
    await _supabase.from('friends').delete().eq('id', friendsRowId);
  }

  Future<void> removeFriends(List<String> friendsRowIds) async {
    await _supabase.from('friends').delete().inFilter('id', friendsRowIds);
  }

  /// Fetch another user's stats (works only if a friendship exists, per RLS).
  Future<StreakStats> fetchFriendStats(String friendUserId) async {
    final rows = await _supabase
        .from('streak_days')
        .select('day')
        .eq('user_id', friendUserId)
        .order('day', ascending: true);

    final daySet = (rows as List)
        .map((r) => DateTime.parse(r['day'] as String))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    int currentStreak = 0;
    var cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    while (daySet.contains(cursor)) {
      currentStreak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final sortedDays = daySet.toList()..sort();
    int longest = 0, running = 0;
    DateTime? prev;
    for (final d in sortedDays) {
      running = (prev != null && d.difference(prev).inDays == 1) ? running + 1 : 1;
      if (running > longest) longest = running;
      prev = d;
    }

    double successRate = 0;
    if (sortedDays.isNotEmpty) {
      final totalPossible = DateTime.now().difference(sortedDays.first).inDays + 1;
      successRate = totalPossible > 0 ? (sortedDays.length / totalPossible) * 100 : 0;
    }

    final now = DateTime.now();
    final daysThisMonth = sortedDays.where((d) => d.year == now.year && d.month == now.month).length;

    final profile = await _supabase.from('profiles').select('xp, full_name').eq('id', friendUserId).maybeSingle();
    final totalXp = (profile?['xp'] as int?) ?? 0;
    final fullName = (profile?['full_name'] as String?) ?? 'Unknown';

    return StreakStats(
      fullName: fullName,
      currentStreak: currentStreak,
      longestStreak: longest,
      successRate: successRate,
      daysThisMonth: daysThisMonth,
      totalXp: totalXp,
    );
  }
}