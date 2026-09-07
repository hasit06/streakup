import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';
import 'streak_progress_screen.dart';
import 'ProfileScreen.dart';

class FlameLogo extends StatelessWidget {
  final double size;
  final String assetPath;

  const FlameLogo({
    super.key,
    this.size = 76.0,
    this.assetPath = 'assets/streak_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF0EC), // not yet in AppColors — flag if you want it added
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Log out')),
        ],
      ),
    );
    if (confirm == true) {
      await Supabase.instance.client.auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      endDrawer: const ProfileScreen(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(context),
              const SizedBox(height: 16),

              Text('Hi, Hasit', style: AppText.title(size: 28)),
              const SizedBox(height: 2),
              Text("Let's make today amazing!", style: AppText.body(size: 14, weight: FontWeight.w700)),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StreakProgressScreen()),
                  );
                },
                child: _buildStreakCard(),
              ),
              const SizedBox(height: 16),

              _buildTodayProgressCard(),
              const SizedBox(height: 16),

              _buildUpcomingTaskCard(),
              const SizedBox(height: 20),

              _buildWeeklyTrackerRow(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: const Icon(Icons.menu_rounded, color: AppColors.ink),
        ),
        Row(
          children: [
            const Icon(Icons.notifications_none_rounded, color: AppColors.ink, size: 28),
            const SizedBox(width: 12),
            Builder(
              builder: (innerContext) => GestureDetector(
                onTap: () => Scaffold.of(innerContext).openEndDrawer(),
                onLongPress: () => _logout(innerContext),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.lightPurple),
                  child: const Icon(Icons.person_rounded, color: AppColors.purple),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: appCard(radius: 28).copyWith(
        boxShadow: [
          BoxShadow(color: AppColors.purple.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          const FlameLogo(size: 88, assetPath: 'assets/streak_logo.png'),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('67', style: AppText.title(size: 48).copyWith(height: 1.0)),
                Text(
                  'DAY STREAK',
                  style: AppText.body(size: 13, weight: FontWeight.w800).copyWith(letterSpacing: 0.5),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.lightPurple, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events_outlined, size: 15, color: AppColors.purple),
                      const SizedBox(width: 4),
                      Text('6700+ Xp', style: AppText.body(size: 12, weight: FontWeight.w800, color: AppColors.purple)),
                      Text('  |  This week', style: AppText.body(size: 11, weight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: appCard(radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: AppText.body(size: 18, weight: FontWeight.w800, color: AppColors.ink),
              children: [
                const TextSpan(text: 'Today, '),
                TextSpan(
                  text: '28th July',
                  style: AppText.body(size: 18, weight: FontWeight.w900, color: AppColors.ink)
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 76,
                height: 76,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 76,
                      height: 76,
                      child: CircularProgressIndicator(
                        value: 6 / 7,
                        strokeWidth: 9,
                        backgroundColor: AppColors.lightPurple,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.purple),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text('6/7', style: AppText.title(size: 20)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(width: 1, height: 50, color: AppColors.cardBorder),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Journal', style: AppText.title(size: 16)),
                        const Icon(Icons.check_circle_outline_rounded, color: AppColors.purple, size: 24),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mood', style: AppText.title(size: 16)),
                        const Icon(Icons.sentiment_satisfied_alt_rounded, color: AppColors.purple, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTaskCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: appCard(radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.lightPurple, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.assignment_outlined, color: AppColors.purple, size: 22),
              ),
              const SizedBox(width: 12),
              Text('Upcoming task', style: AppText.title(size: 16)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightPurple.withOpacity(0.4),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.radio_button_unchecked_rounded, color: AppColors.sub, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Study Data Structures', style: AppText.body(size: 14, weight: FontWeight.w800, color: AppColors.ink)),
                      Row(
                        children: [
                          const Icon(Icons.menu_book_rounded, size: 13, color: AppColors.purple),
                          const SizedBox(width: 4),
                          Text('Study', style: AppText.body(size: 12, weight: FontWeight.w700, color: AppColors.purple)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.sub, size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrackerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDayCapsule('M', const Color(0xFFE9F8EE), AppColors.success, iconType: 'dot'),
        _buildDayCapsule('T', const Color(0xFFFCEAEB), AppColors.error, iconType: 'dot'),
        _buildDayCapsule('W', const Color(0xFFFFF7E5), const Color(0xFFF2C94C), iconType: 'dot'),
        _buildDayCapsule('Th', const Color(0xFFFFEFE5), const Color(0xFFF2994A), iconType: 'minus'),
        _buildDayCapsule('F', const Color(0xFFE9F8EE), AppColors.success, iconType: 'dot'),
        _buildDayCapsule('Sa', AppColors.lightPurple, AppColors.purple, iconType: 'circle'),
        _buildDayCapsule('S', AppColors.lightPurple, AppColors.purple, iconType: 'circle'),
      ],
    );
  }

  Widget _buildDayCapsule(String day, Color bgColor, Color iconColor, {required String iconType}) {
    return Container(
      width: 42,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(day, style: AppText.body(size: 14, weight: FontWeight.w800, color: AppColors.ink)),
          const SizedBox(height: 8),
          if (iconType == 'dot')
            Container(width: 14, height: 14, decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle))
          else if (iconType == 'minus')
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: const Center(child: Icon(Icons.remove, size: 10, color: Colors.white)),
            )
          else
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: iconColor, width: 2)),
            ),
        ],
      ),
    );
  }
}