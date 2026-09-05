import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'streak_progress_screen.dart';

class FlameLogo extends StatelessWidget {
  final double size;
  final String assetPath;

  const FlameLogo({
    super.key,
    this.size = 76.0,
    this.assetPath = 'assets/streak_logo.png' //o your logo image in pubspec.yaml
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFFF0EC), // Soft peach background matching the UI
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0), // Adjust inner padding as needed
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
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
      // No manual navigation needed — AuthGate listens for the
      // signedOut event and automatically shows LoginScreen.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF), // Soft background tint
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar Navigation
              _buildTopHeader(context),
              const SizedBox(height: 16),

              // 2. Greeting
              Text(
                'Hi, Hasit',
                style: GoogleFonts.nunito(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E1C3B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Let's make today amazing!",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8B8C9E),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Streak Card (Tapping opens Streak Progress Screen)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StreakProgressScreen(),
                    ),
                  );
                },
                child: _buildStreakCard(),
              ),
              const SizedBox(height: 16),

              // 4. Today Progress Card (6/7 Gauge + Journal/Mood)
              _buildTodayProgressCard(),
              const SizedBox(height: 16),

              // 5. Upcoming Task Card
              _buildUpcomingTaskCard(),
              const SizedBox(height: 20),

              // 6. Weekly Day Tracker Row
              _buildWeeklyTrackerRow(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header Bar Widget
  Widget _buildTopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.menu_rounded, color: Color(0xFF1E1C3B)),
        ),
        Row(
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF1E1C3B),
              size: 28,
            ),
            const SizedBox(width: 12),
            // TEMP: long-press profile icon to log out until a real
            // settings/profile screen exists.
            GestureDetector(
              onLongPress: () => _logout(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE2DDFE),
                ),
                child: const Icon(Icons.person_rounded, color: Color(0xFF6C5CE7)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Card 1: Streak Banner with Custom Asset Flame Logo
  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEFEFFE)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Custom Asset Logo Container
          const FlameLogo(
              size: 88,
              assetPath: 'assets/streak_logo.png'
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '67',
                  style: GoogleFonts.nunito(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E1C3B),
                    height: 1.0,
                  ),
                ),
                Text(
                  'DAY STREAK',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8B8C9E),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1EFFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events_outlined,
                        size: 15,
                        color: Color(0xFF6C5CE7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '6700+ Xp',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6C5CE7),
                        ),
                      ),
                      Text(
                        '  |  This week',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF8B8C9E),
                        ),
                      ),
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

  // Card 2: Daily Progress Status
  Widget _buildTodayProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEFEFFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.nunito(fontSize: 18, color: const Color(0xFF1E1C3B)),
              children: [
                const TextSpan(
                  text: 'Today, ',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(
                  text: '28th July',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular Progress Indicator (6/7)
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
                        backgroundColor: const Color(0xFFF1EFFF),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C5CE7),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '6/7',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E1C3B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(width: 1, height: 50, color: const Color(0xFFEFEFFE)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Journal',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1C3B),
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Color(0xFF6C5CE7),
                          size: 24,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mood',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1C3B),
                          ),
                        ),
                        const Icon(
                          Icons.sentiment_satisfied_alt_rounded,
                          color: Color(0xFF6C5CE7),
                          size: 24,
                        ),
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

  // Card 3: Upcoming Task Card
  Widget _buildUpcomingTaskCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEFEFFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1EFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF6C5CE7),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Upcoming task',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E1C3B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F8FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.radio_button_unchecked_rounded,
                  color: Color(0xFF8B8C9E),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Study Data Structures',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E1C3B),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.menu_book_rounded,
                            size: 13,
                            color: Color(0xFF6C5CE7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Study',
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6C5CE7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8B8C9E),
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Row 4: Weekly Habit Tracker Row
  Widget _buildWeeklyTrackerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDayCapsule('M', const Color(0xFFE9F8EE), const Color(0xFF27AE60), iconType: 'dot'),
        _buildDayCapsule('T', const Color(0xFFFCEAEB), const Color(0xFFEB5757), iconType: 'dot'),
        _buildDayCapsule('W', const Color(0xFFFFF7E5), const Color(0xFFF2C94C), iconType: 'dot'),
        _buildDayCapsule('Th', const Color(0xFFFFEFE5), const Color(0xFFF2994A), iconType: 'minus'),
        _buildDayCapsule('F', const Color(0xFFE9F8EE), const Color(0xFF27AE60), iconType: 'dot'),
        _buildDayCapsule('Sa', const Color(0xFFF1EFFF), const Color(0xFF6C5CE7), iconType: 'circle'),
        _buildDayCapsule('S', const Color(0xFFF1EFFF), const Color(0xFF6C5CE7), iconType: 'circle'),
      ],
    );
  }

  Widget _buildDayCapsule(String day, Color bgColor, Color iconColor, {required String iconType}) {
    return Container(
      width: 42,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E1C3B),
            ),
          ),
          const SizedBox(height: 8),
          if (iconType == 'dot')
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            )
          else if (iconType == 'minus')
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: const Center(
                child: Icon(Icons.remove, size: 10, color: Colors.white),
              ),
            )
          else
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: iconColor, width: 2),
              ),
            ),
        ],
      ),
    );
  }
}