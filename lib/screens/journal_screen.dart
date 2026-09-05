import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_widgets.dart';

class JournalScreenContent extends StatefulWidget {
  const JournalScreenContent({super.key});
  @override
  State<JournalScreenContent> createState() => _JournalScreenContentState();
}

class _JournalScreenContentState extends State<JournalScreenContent> {
  final _entry = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        const AppTopBar(),
        const SizedBox(height: 18),
        Text('Journal', style: GoogleFonts.schoolbell(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.ink)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: softCard(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.purple),
                      const SizedBox(width: 10),
                      Text('13th Aug, 2026', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFEDEBFB), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.purple),
                        const SizedBox(width: 4),
                        Text('View Calendar', style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w800, color: AppColors.purple)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: TextField(
                  controller: _entry,
                  maxLines: null,
                  style: GoogleFonts.nunito(fontSize: 14, color: AppColors.ink),
                  decoration: InputDecoration(
                    hintText: 'How was your day?',
                    hintStyle: GoogleFonts.nunito(color: AppColors.sub),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.purple.withOpacity(0.3)),
                        backgroundColor: const Color(0xFFF6F2FF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.purple),
                      label: Text('AI Suggestion', style: GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.purple)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.purple.withOpacity(0.3)),
                        backgroundColor: const Color(0xFFF6F2FF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.favorite_border_rounded, size: 16, color: AppColors.purple),
                      label: Text('Save Journal', style: GoogleFonts.nunito(fontSize: 12.5, fontWeight: FontWeight.w800, color: AppColors.purple)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: softCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sentiment_satisfied_rounded, size: 18, color: AppColors.ink),
                      const SizedBox(width: 8),
                      Text("Yesterday's Insights", style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.ink)),
                    ],
                  ),
                  const Icon(Icons.more_horiz_rounded, color: AppColors.purple),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Latest entry', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink)),
                          const SizedBox(height: 4),
                          Text('Felt productive today! Completed my tasks and learned something new.', style: GoogleFonts.nunito(fontSize: 11.5, color: AppColors.sub, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: const Color(0xFFEDEBFB), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.menu_book_rounded, color: AppColors.purple, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}