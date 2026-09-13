import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_widgets.dart';
import 'settings.dart'; // adjust if your settings file path differs

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: Column(
        children: [
          // Top bar: back, title, settings
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.purple, size: 26),
                ),
                Text(
                  'Profile',
                  style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.ink),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                  child: const Icon(Icons.settings_outlined, color: AppColors.purple, size: 26),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    icon: Icons.person_outline_rounded,
                    title: 'Avatar',
                    subtitle: 'Choose your avatar',
                    trailing: _avatarThumbnails(),
                    onTap: () {},
                  ),
                  _buildInfoRow(
                    icon: Icons.person_outline_rounded,
                    title: 'Name',
                    subtitle: 'Hasit',
                    onTap: () {},
                  ),
                  _buildInfoRow(
                    icon: Icons.alternate_email_rounded,
                    title: 'Username',
                    subtitle: '@hasit_07',
                    onTap: () {},
                  ),
                  _buildInfoRow(
                    icon: Icons.calendar_today_rounded,
                    title: 'Birthday',
                    subtitle: '28th July 2004',
                    onTap: () {},
                  ),
                  const SizedBox(height: 4),
                  _buildStatsRow(),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.bar_chart_rounded,
                    title: 'Habit Stats',
                    subtitle: 'View your habit trends and insights',
                    onTap: () {},
                  ),
                  _buildInfoRow(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    subtitle: 'Notifications, privacy and more',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: softCard(radius: 22),
      child: Row(
        children: [
          Stack(
            children: [
              ClipOval(
                child: Container(
                  width: 68,
                  height: 68,
                  color: AppColors.purple.withOpacity(0.1),
                  child: Image.asset(
                    'assets/avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded, color: AppColors.purple, size: 36),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(color: AppColors.purple, shape: BoxShape.circle),
                  child: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hasit', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.ink)),
                Text('@hasit_07', style: GoogleFonts.nunito(fontSize: 13, color: AppColors.sub, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Small steps. Big progress. 💜',
                        style: GoogleFonts.nunito(fontSize: 12.5, color: AppColors.sub, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFFEDEBFB), borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 15, color: AppColors.purple),
                  const SizedBox(width: 6),
                  Text('Edit Profile', style: GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.purple)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarThumbnails() {
    return SizedBox(
      width: 96,
      height: 32,
      child: Stack(
        children: [
          _thumb(0, selected: true),
          _thumb(20),
          _thumb(40),
        ],
      ),
    );
  }

  Widget _thumb(double left, {bool selected = false}) {
    return Positioned(
      left: left,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: selected ? Border.all(color: AppColors.purple, width: 2) : null,
          color: Colors.grey.shade200,
        ),
        child: const Icon(Icons.person_rounded, size: 18, color: AppColors.sub),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: softCard(radius: 18),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: const Color(0xFFEDEBFB), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: AppColors.purple, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    Text(subtitle, style: GoogleFonts.nunito(fontSize: 12, color: AppColors.sub, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (trailing != null) trailing,
              if (trailing == null) const Icon(Icons.chevron_right_rounded, color: AppColors.sub, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: softCard(radius: 18, fill: const Color(0xFFEDEBFB).withOpacity(0.6)),
      child: Row(
        children: [
          Expanded(child: _stat('🔥', '67', 'Day Streak')),
          Container(width: 1, height: 40, color: AppColors.cardBorder),
          Expanded(child: _stat('📖', '112', 'Total Journal\nEntries', isIcon: Icons.menu_book_rounded)),
          Container(width: 1, height: 40, color: AppColors.cardBorder),
          Expanded(child: _stat('✅', '48', 'Completed Tasks', isIcon: Icons.check_circle_outline_rounded)),
        ],
      ),
    );
  }

  Widget _stat(String emoji, String value, String label, {IconData? isIcon}) {
    return Column(
      children: [
        isIcon != null
            ? Icon(isIcon, color: AppColors.purple, size: 20)
            : Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.ink)),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(fontSize: 10.5, color: AppColors.sub, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}