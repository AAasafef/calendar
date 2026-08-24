import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/calendar_entry.dart';
import '../services/calendar_store.dart';
import '../theme/ciantis_theme.dart';

/// Lightweight Tasks tab — pulls any entry typed "Task" out of the shared
/// store into a simple checklist, styled consistently with the rest of the
/// app. Not a full replica of the reference's combined calendar+tasks
/// screen, but keeps the same paper/serif language.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final CalendarStore _store = CalendarStore();
  List<CalendarEntry> _entries = [];
  final Set<String> _done = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await _store.load();
    if (!mounted) return;
    setState(() => _entries = loaded.where((e) => e.type == 'Task').toList()..sort((a, b) => a.start.compareTo(b.start)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CiantisColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 15, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tasks',
                style: GoogleFonts.cormorantGaramond(fontSize: 30, fontWeight: FontWeight.w500, color: CiantisColors.ink),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _entries.isEmpty
                    ? const Center(
                        child: Text('No tasks yet — add one from the calendar.', style: TextStyle(color: CiantisColors.muted, fontSize: 12)),
                      )
                    : ListView.separated(
                        itemCount: _entries.length,
                        separatorBuilder: (_, __) => const Divider(color: CiantisColors.rule, height: 1),
                        itemBuilder: (context, index) {
                          final task = _entries[index];
                          final done = _done.contains(task.id);
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () => setState(() => done ? _done.remove(task.id) : _done.add(task.id)),
                            leading: Icon(
                              done ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                              color: done ? CiantisColors.active : CiantisColors.muted,
                              size: 21,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 13,
                                color: done ? CiantisColors.muted : CiantisColors.ink,
                                decoration: done ? TextDecoration.lineThrough : null,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
