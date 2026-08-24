import 'package:flutter/material.dart';
import '../models/calendar_entry.dart';
import '../services/calendar_store.dart';
import '../theme/ciantis_theme.dart';
import '../widgets/ciantis_bottom_nav.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'more_screen.dart';
import 'tasks_screen.dart';

/// Owns the shared bottom nav (Home / Calendar / + / Tasks / More) and
/// switches between the tab screens, matching the reference's nav bar
/// across every screen.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  int _reloadTick = 0;
  final CalendarStore _store = CalendarStore();

  // Keyed on _reloadTick so that saving a new event (from quick-add) forces
  // Home/Calendar/Tasks to recreate their state and re-read from storage,
  // while switching tabs in between keeps each screen's state (scroll
  // position, selected day, etc.) untouched.
  List<Widget> _pages() => [
        HomeScreen(key: ValueKey('home_$_reloadTick')),
        CalendarScreen(key: ValueKey('cal_$_reloadTick')),
        TasksScreen(key: ValueKey('tasks_$_reloadTick')),
        const MoreScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CiantisColors.bg,
      body: IndexedStack(index: _index, children: _pages()),
      bottomNavigationBar: CiantisBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        onAddTap: _showQuickAdd,
      ),
    );
  }

  Future<void> _showQuickAdd() async {
    final title = TextEditingController();
    DateTime date = DateTime.now();
    TimeOfDay time = TimeOfDay.now();
    String type = 'Task';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CiantisColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(22, 22, 22, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('New event', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: CiantisColors.ink)),
                const SizedBox(height: 12),
                TextField(
                  controller: title,
                  autofocus: true,
                  style: const TextStyle(color: CiantisColors.ink),
                  decoration: const InputDecoration(hintText: 'e.g. Coffee with Sam', border: InputBorder.none),
                ),
                const Divider(color: CiantisColors.rule, height: 1),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(date.year - 1),
                            lastDate: DateTime(date.year + 3),
                          );
                          if (picked != null) setSheetState(() => date = picked);
                        },
                        child: Text('${date.month}/${date.day}/${date.year}'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showTimePicker(context: context, initialTime: time);
                          if (picked != null) setSheetState(() => time = picked);
                        },
                        child: Text(time.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: type,
                  items: CiantisColors.typeColors.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setSheetState(() => type = v ?? type),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: CiantisColors.active, foregroundColor: Colors.white),
                    onPressed: () async {
                      if (title.text.trim().isEmpty) return;
                      final start = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      final entries = await _store.load();
                      entries.add(CalendarEntry(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        title: title.text.trim(),
                        start: start,
                        end: start.add(const Duration(hours: 1)),
                        type: type,
                      ));
                      await _store.save(entries);
                      if (sheetContext.mounted) Navigator.pop(sheetContext);
                      setState(() => _reloadTick++);
                    },
                    child: const Text('Add event'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
