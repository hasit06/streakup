import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_widgets.dart';

class CommunityScreenContent extends StatefulWidget {
  const CommunityScreenContent({super.key});

  @override
  State<CommunityScreenContent> createState() => _CommunityScreenContentState();
}

class _CommunityScreenContentState extends State<CommunityScreenContent> {
  bool _groupsTab = false;

  final _friends = const [
    {'name': 'Druov', 'streak': 42, 'mutual': 18},
    {'name': 'Miten', 'streak': 29, 'mutual': 12},
    {'name': 'Viraj', 'streak': 15, 'mutual': 9},
  ];

  final _groups = const [
    {'name': 'Study Warriors', 'icon': Icons.groups_rounded, 'color': AppColors.purple, 'streak': 42, 'members': 18},
    {'name': 'Coding Ninjas', 'icon': Icons.security_rounded, 'color': AppColors.purple, 'streak': 17, 'members': 12},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        const AppTopBar(),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Community', style: GoogleFonts.schoolbell(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.ink)),
            Container(
              width: 36,
              height: 36,
              decoration: softCard(radius: 12),
              child: Icon(_groupsTab ? Icons.search_rounded : Icons.add_rounded, size: 20, color: AppColors.purple),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _tabBtn('Groups', _groupsTab, () => setState(() => _groupsTab = true)),
            const SizedBox(width: 24),
            _tabBtn('Friends', !_groupsTab, () => setState(() => _groupsTab = false)),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: softCard(),
          child: Column(
            children: _groupsTab ? _buildGroups() : _buildFriends(),
          ),
        ),
      ],
    );
  }

  Widget _tabBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w800, color: active ? AppColors.purple : AppColors.sub)),
          const SizedBox(height: 4),
          Container(height: 3, width: 40, color: active ? AppColors.purple : Colors.transparent),
        ],
      ),
    );
  }

  List<Widget> _buildFriends() {
    return _friends.map((f) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFEDEBFB),
              child: Icon(Icons.person_rounded, color: AppColors.purple),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f['name'] as String, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 14, color: AppColors.orange),
                      Text(' ${f['streak']} day streak', style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.purple)),
                      Text('   |   ', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.sub)),
                      const Icon(Icons.people_alt_rounded, size: 13, color: AppColors.purple),
                      Text(' ${f['mutual']} Mutual Friends', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.sub)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_vert_rounded, color: AppColors.purple),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildGroups() {
    return [
      ..._groups.map((g) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: const Color(0xFFEDEBFB), borderRadius: BorderRadius.circular(14)),
              child: Icon(g['icon'] as IconData, color: AppColors.purple, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g['name'] as String, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, size: 14, color: AppColors.orange),
                      Text(' ${g['streak']} day streak', style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.purple)),
                      Text('   |   ', style: GoogleFonts.nunito(fontSize: 11, color: AppColors.sub)),
                      const Icon(Icons.people_alt_rounded, size: 13, color: AppColors.purple),
                      Text(' ${g['members']} Members', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.sub)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.purple),
          ],
        ),
      )),
      const SizedBox(height: 10),
      _actionCard(Icons.add_rounded, 'Create group', 'Start a new group and invite members'),
      const SizedBox(height: 10),
      _actionCard(Icons.link_rounded, 'Join via code', 'Enter a code to join an existing group'),
    ];
  }

  Widget _actionCard(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: AppColors.purple, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.nunito(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.purple)),
                Text(sub, style: GoogleFonts.nunito(fontSize: 11, color: AppColors.sub, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}