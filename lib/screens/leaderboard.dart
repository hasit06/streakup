import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_widgets.dart';
import 'group_members.dart';

class GroupMember {
  final String name;
  final int xp;
  final bool isYou;
  const GroupMember({required this.name, required this.xp, this.isYou = false});
}

class GroupDetailScreen extends StatelessWidget {
  final String groupName;
  final String tagline;
  final IconData icon;
  final int streak;
  final int memberCount;
  final int goalDays;
  final List<GroupMember> members;

  const GroupDetailScreen({
    super.key,
    required this.groupName,
    required this.tagline,
    required this.icon,
    required this.streak,
    required this.memberCount,
    this.goalDays = 50,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...members]..sort((a, b) => b.xp.compareTo(a.xp));

    return GradientScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.purple, size: 26),
                ),
                const Icon(Icons.more_vert_rounded, color: AppColors.ink, size: 24),
              ],
            ),
            const SizedBox(height: 16),
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildProgressCard(),
            const SizedBox(height: 16),
            _buildLeaderboardCard(sorted),
            const SizedBox(height: 20),
            _buildLeaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: const Color(0xFFEDEBFB), borderRadius: BorderRadius.circular(18)),
          child: Icon(icon, color: AppColors.purple, size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(groupName, style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.ink)),
              Text(tagline, style: GoogleFonts.nunito(fontSize: 12.5, color: AppColors.sub, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupMembersScreen(
                      groupName: groupName,
                      tagline: tagline,
                      icon: icon,
                      memberCount: memberCount,
                      members: members
                          .map((m) => GroupMemberEntry(name: m.isYou ? '${m.name} (You)' : m.name))
                          .toList(),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people_alt_rounded, size: 14, color: AppColors.purple),
                    Text(' $memberCount Members', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.sub)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard() {
    final progress = (streak / goalDays).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: softCard(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Group Progress', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.ink)),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.purple),
                  children: [
                    TextSpan(text: '$streak'),
                    TextSpan(text: ' / $goalDays days', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.sub)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE2DDFE),
                    valueColor: const AlwaysStoppedAnimation(AppColors.purple),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.local_fire_department_rounded, color: AppColors.orange, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Keep going! ${goalDays - streak} more days to reach $goalDays days!',
            style: GoogleFonts.nunito(fontSize: 12.5, color: AppColors.sub, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardCard(List<GroupMember> sorted) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: softCard(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Leaderboard', style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.ink)),
              Text('Total XP', style: GoogleFonts.nunito(fontSize: 12, color: AppColors.sub, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(sorted.length, (i) {
              final m = sorted[i];
              final rank = i + 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 28, child: _rankBadge(rank)),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFEDEBFB),
                          child: Icon(Icons.person_rounded, color: AppColors.purple),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            m.isYou ? '${m.name} (You)' : m.name,
                            style: GoogleFonts.nunito(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.ink),
                          ),
                        ),
                        Text('${m.xp} XP', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.purple)),
                      ],
                    ),
                  ),
                  if (i != sorted.length - 1) const Divider(height: 1, color: AppColors.cardBorder),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _rankBadge(int rank) {
    final medalColors = {
      1: const Color(0xFFF2C94C), // gold
      2: const Color(0xFFB8BCC8), // silver
      3: const Color(0xFFD08A5B), // bronze
    };
    if (medalColors.containsKey(rank)) {
      return Icon(Icons.emoji_events_rounded, color: medalColors[rank], size: 22);
    }
    return Text(
      '$rank',
      style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.sub),
    );
  }

  Widget _buildLeaveButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFFFE5E5), borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text('Leave Group', style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}