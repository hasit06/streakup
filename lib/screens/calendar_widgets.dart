import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalColors {
  static const purple = Color(0xFF6C5CE7);
  static const ink = Color(0xFF1E1C3B);
  static const sub = Color(0xFF8B8C9E);
}

class MonthlyStreakCalendar extends StatefulWidget {
  final int freezeDay;
  const MonthlyStreakCalendar({super.key, this.freezeDay = 5});

  @override
  State<MonthlyStreakCalendar> createState() => _MonthlyStreakCalendarState();
}

class _MonthlyStreakCalendarState extends State<MonthlyStreakCalendar> {
  final DateTime _today = DateTime.now();
  late DateTime _visibleMonth;
  late Set<int> _completedDays;

  @override
  void initState() {
    super.initState();
    _visibleMonth = DateTime(_today.year, _today.month, 1);
    _completedDays = _mockCompletedDays(_visibleMonth);
  }

  Set<int> _mockCompletedDays(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final upTo = (month.year == _today.year && month.month == _today.month)
        ? _today.day
        : daysInMonth;
    return {for (int d = 1; d <= upTo; d++) d};
  }

  void _changeMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta, 1);
      _completedDays = _mockCompletedDays(_visibleMonth);
    });
  }

  String _monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    const weekdayLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final daysInMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_visibleMonth.year, _visibleMonth.month, 1).weekday % 7;

    final cells = <int?>[
      ...List.filled(firstWeekday, null),
      ...List.generate(daysInMonth, (i) => i + 1),
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _changeMonth(-1),
              child: const Icon(Icons.chevron_left_rounded, color: CalColors.sub),
            ),
            Text('${_monthName(_visibleMonth.month)} ${_visibleMonth.year}',
                style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w900, color: CalColors.ink)),
            GestureDetector(
              onTap: () => _changeMonth(1),
              child: const Icon(Icons.chevron_right_rounded, color: CalColors.sub),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFEFEFFE)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Monthly', style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w800, color: CalColors.ink)),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: CalColors.sub),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: weekdayLabels
              .map((d) => Expanded(
            child: Center(
              child: Text(d, style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w700, color: CalColors.sub)),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final day = cells[index];
            if (day == null) return const SizedBox.shrink();

            final isToday = _visibleMonth.year == _today.year &&
                _visibleMonth.month == _today.month &&
                day == _today.day;
            final isCompleted = _completedDays.contains(day);
            final isFreeze = day == widget.freezeDay &&
                _visibleMonth.year == _today.year &&
                _visibleMonth.month == _today.month;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCompleted ? CalColors.purple : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isCompleted ? Border.all(color: CalColors.purple, width: 2) : null,
                  ),
                  child: Text(
                    '$day',
                    style: GoogleFonts.nunito(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: isCompleted ? Colors.white : (isToday ? CalColors.purple : CalColors.ink),
                    ),
                  ),
                ),
                if (isFreeze)
                  const Positioned(
                    top: -2,
                    right: -2,
                    child: Icon(Icons.eco_rounded, size: 13, color: Color(0xFF4CAF7D)),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: CalColors.purple, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 6),
            Text('Completed', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: CalColors.sub)),
            const SizedBox(width: 16),
            const Icon(Icons.eco_rounded, size: 14, color: Color(0xFF4CAF7D)),
            const SizedBox(width: 6),
            Text('Freeze used', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w700, color: CalColors.sub)),
          ],
        ),
      ],
    );
  }
}