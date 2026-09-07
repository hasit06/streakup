import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'streak_progress_screen.dart';
import 'calendar_screen.dart';
import 'notifications_screen.dart';

class _Task {
  String title;
  bool completed;
  _Task(this.title, {this.completed = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

enum _Filter { all, pending, completed }

class _TodoScreenState extends State<TodoScreen> {
  final List<_Task> _tasks = [
    _Task('Finish UI Design'),
    _Task('Prepare Project Report'),
    _Task('Revise Database Concepts'),
    _Task('Buy Groceries', completed: true),
  ];

  _Filter _filter = _Filter.all;

  List<_Task> get _visibleTasks {
    switch (_filter) {
      case _Filter.pending:
        return _tasks.where((t) => !t.completed).toList();
      case _Filter.completed:
        return _tasks.where((t) => t.completed).toList();
      case _Filter.all:
        return _tasks;
    }
  }

  void _addTask() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('New Task', style: GoogleFonts.nunito(fontWeight: FontWeight.w900)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Task title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C5CE7)),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() => _tasks.insert(0, _Task(text)));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteTask(_Task task) {
    setState(() => _tasks.remove(task));
  }

  String _ordinal(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  String _weekdayName(int weekday) {
    const names = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return names[weekday - 1];
  }

  String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return names[month - 1];
  }

  // Change build() to return the content directly instead of a Scaffold:
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),
          const SizedBox(height: 12),
          Text(
            'To-do List',
            style: GoogleFonts.schoolbell(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF1E1C3B)),
          ),
          const SizedBox(height: 16),
          _buildInfoCards(now),
          const SizedBox(height: 16),
          _buildFilterTabs(),
          const SizedBox(height: 16),
          _buildAddTaskRow(),
          const SizedBox(height: 12),
          _buildTaskList(),
        ],
      ),
    );
  }

// And update _buildTopBar's avatar (currently a dead-end Container) to this:
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // The back arrow no longer makes sense on a bottom-nav tab (nothing to pop to)
        // — safe to leave as-is since Navigator.canPop already guards it, or remove entirely.
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: const Icon(Icons.checklist_rounded, color: Color(0xFF1E1C3B)), // swapped for a static icon since there's nothing to go "back" to
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded, color: Color(0xFF1E1C3B), size: 26),
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Builder(
              builder: (innerContext) => GestureDetector(
                onTap: () => Scaffold.of(innerContext).openEndDrawer(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE2DDFE)),
                  child: const Icon(Icons.person_rounded, color: Color(0xFF6C5CE7)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildInfoCards(DateTime now) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen())),
            child: _infoCard(
              icon: Icons.calendar_month_rounded,
              iconBg: const Color(0xFFEDEBFB),
              iconColor: const Color(0xFF6C5CE7),
              topLine: '${_ordinal(now.day)} ${_monthName(now.month)}, ${now.year}',
              subLine: _weekdayName(now.weekday),
              actionLabel: 'View calendar',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StreakProgressScreen())),
            child: _infoCard(
              icon: Icons.local_fire_department_rounded,
              iconBg: const Color(0xFFFFF0EC),
              iconColor: const Color(0xFFFF7A45),
              topLine: '67',
              topLineSuffix: 'day streak',
              subLine: '6700+ Xp',
              actionLabel: 'See progress',
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String topLine,
    String? topLineSuffix,
    required String subLine,
    required String actionLabel,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECEFFC), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: topLineSuffix == null
                    ? Text(topLine,
                    style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w900, color: const Color(0xFF1E1C3B)))
                    : Text(topLine,
                    style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF1E1C3B))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(subLine, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF8B8C9E))),
          const Divider(height: 18, color: Color(0xFFECEFFC)),
          Row(
            children: [
              Expanded(
                child: Text(actionLabel,
                    style: GoogleFonts.nunito(fontSize: 11.5, fontWeight: FontWeight.w800, color: const Color(0xFF6C5CE7))),
              ),
              const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF6C5CE7)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    Widget tab(String label, _Filter value) {
      final active = _filter == value;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _filter = value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFEDEBFB) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(label,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: active ? const Color(0xFF6C5CE7) : const Color(0xFF8B8C9E),
                  )),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEFFC), width: 1.2),
      ),
      child: Row(
        children: [
          tab('All tasks', _Filter.all),
          tab('Pending', _Filter.pending),
          tab('Completed', _Filter.completed),
        ],
      ),
    );
  }

  Widget _buildAddTaskRow() {
    return GestureDetector(
      onTap: _addTask,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFECEFFC), width: 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Color(0xFF6C5CE7), shape: BoxShape.circle),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Add New Task',
                  style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w800, color: const Color(0xFF6C5CE7))),
            ),
            const Icon(Icons.auto_awesome_rounded, size: 18, color: Color(0xFF6C5CE7)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = _visibleTasks;
    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('No tasks here', style: GoogleFonts.nunito(color: const Color(0xFF8B8C9E), fontWeight: FontWeight.w700)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFECEFFC), width: 1.2),
      ),
      child: Column(
        children: List.generate(tasks.length, (i) {
          final task = tasks[i];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => task.completed = !task.completed),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.completed ? const Color(0xFF6C5CE7) : Colors.transparent,
                          border: Border.all(color: const Color(0xFF6C5CE7), width: 2),
                        ),
                        child: task.completed ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        task.title,
                        style: GoogleFonts.nunito(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: task.completed ? const Color(0xFF8B8C9E) : const Color(0xFF1E1C3B),
                          decoration: task.completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF8B8C9E)),
                      onSelected: (value) {
                        if (value == 'delete') _deleteTask(task);
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ],
                ),
              ),
              if (i != tasks.length - 1) const Divider(height: 1, color: Color(0xFFECEFFC)),
            ],
          );
        }),
      ),
    );
  }
}