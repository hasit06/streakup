import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppGradient {
  static const bg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFA9D6FF), Color(0xFFC9D9FF), Color(0xFFDDD2FF)],
  );
}

class AppColors {
  static const purple = Color(0xFF6C5DD3);
  static const ink = Color(0xFF1E1B3A);
  static const sub = Color(0xFF6F6C8C);
  static const cardBorder = Color(0xFFECEFFC);
  static const green = Color(0xFF4CAF7D);
  static const orange = Color(0xFFFF7A45);
}

BoxDecoration softCard({double radius = 22, Color? fill}) => BoxDecoration(
  color: fill ?? Colors.white.withOpacity(0.85),
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: AppColors.cardBorder, width: 1.2),
  boxShadow: [
    BoxShadow(
      color: AppColors.purple.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ],
);

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  const GradientScaffold({super.key, required this.child, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradient.bg),
        child: SafeArea(child: child),
      ),
    );
  }
}

class AppTopBar extends StatelessWidget {
  final VoidCallback? onBack;
  const AppTopBar({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _circleBtn(icon: Icons.arrow_back_rounded, onTap: onBack ?? () {}),
        Row(
          children: [
            _circleBtn(icon: Icons.notifications_none_rounded, badge: true, onTap: () {}),
            const SizedBox(width: 10),
            ClipOval(
              child: Container(
                width: 44,
                height: 44,
                color: Colors.white,
                child: Image.asset(
                  'assets/avatar.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded, color: AppColors.purple, size: 26),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _circleBtn({required IconData icon, required VoidCallback onTap, bool badge = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: softCard(radius: 14, fill: Colors.white.withOpacity(0.9)),
        child: Stack(
          children: [
            Center(child: Icon(icon, color: AppColors.ink, size: 20)),
            if (badge)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;
  const AppBottomNav({super.key, required this.index, required this.onTap, required this.onAdd});

  static const _icons = [
    Icons.home_rounded,
    Icons.assignment_turned_in_rounded,
    null,
    Icons.menu_book_rounded,
    Icons.groups_rounded
  ];
  static const _labels = ['Home', 'Tasks', '', 'Journal', 'Social'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (i) {
            if (i == 2) {
              return GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [AppColors.purple, Color(0xFF8B7BE8)]),
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                ),
              );
            }
            final navIdx = i < 2 ? i : i - 1;
            final active = index == navIdx;
            return GestureDetector(
              onTap: () => onTap(navIdx),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFEDEBFB) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_icons[i], size: 21, color: active ? AppColors.purple : AppColors.sub),
                    const SizedBox(height: 2),
                    Text(
                      _labels[i],
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: active ? AppColors.purple : AppColors.sub,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}