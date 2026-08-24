import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/calendar_entry.dart';
import '../services/calendar_store.dart';

enum CalendarMode { day, week, month, year }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _bg = Color(0xFFF6F2EC);
  static const _card = Color(0xFFF8F4EE);
  static const _ink = Color(0xFF4A4039);
  static const _muted = Color(0xFF9A918B);
  static const _active = Color(0xFF76675C);
  static const _tabFill = Color(0xFFE9E1D8);
  static const _rule = Color(0x1A4A4039);

  final CalendarStore _store = CalendarStore();
  CalendarMode _mode = CalendarMode.month;
  DateTime _visibleMonth = DateTime(2026, 8, 1);
  DateTime _selected = DateTime(2026, 8, 26);
  List<CalendarEntry> _entries = [];

  final Map<String, Color> _typeColors = const {
    'Work': Color(0xFF90A999),
    'Meeting': Color(0xFFAAA4C1),
    'Health': Color(0xFFC59A8B),
    'Family': Color(0xFFD1A7B0),
    'Task': Color(0xFFC9A862),
    'School': Color(0xFF8CAEA7),
    'Reminder': Color(0xFFBFA8C7),
    'Appointment': Color(0xFF94AFC6),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await _store.load();
    if (!mounted) return;
    setState(() => _entries = loaded);
  }

  Future<void> _save() => _store.save(_entries);

  bool _sameDay(DateTime a, DateTime b) => DateUtils.isSameDay(a, b);

  List<CalendarEntry> _entriesFor(DateTime day) {
    final result = _entries.where((e) => _sameDay(e.start, day)).toList();
    result.sort((a, b) => a.start.compareTo(b.start));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabs(),
            Expanded(child: _buildMode()),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 15, 17, 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Calendar',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 35,
                height: 1,
                fontWeight: FontWeight.w500,
                color: _ink,
                letterSpacing: -0.8,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showEntrySheet(),
            icon: const Icon(CupertinoIcons.add, size: 24, color: _ink),
          ),
          IconButton(
            onPressed: _showOptions,
            icon: const Icon(CupertinoIcons.ellipsis, size: 24, color: _ink),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    const labels = <CalendarMode, String>{
      CalendarMode.day: 'Day',
      CalendarMode.week: 'Week',
      CalendarMode.month: 'Month',
      CalendarMode.year: 'Year',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 15),
      child: SizedBox(
        height: 47,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: labels.entries.map((entry) {
            final active = _mode == entry.key;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _mode = entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: active ? 45 : 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? _active : _tabFill,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: active ? Colors.white : _ink,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMode() {
    switch (_mode) {
      case CalendarMode.day:
        return _dayView();
      case CalendarMode.week:
        return _weekView();
      case CalendarMode.year:
        return _yearView();
      case CalendarMode.month:
        return _monthView();
    }
  }

  Widget _monthView() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      children: [
        Container(
          height: 460,
          padding: const EdgeInsets.fromLTRB(15, 18, 15, 13),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(19),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => _shiftMonth(-1),
                    icon: const Icon(CupertinoIcons.chevron_left, size: 15, color: _ink),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat('MMMM yyyy').format(_visibleMonth),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _shiftMonth(1),
                    icon: const Icon(CupertinoIcons.chevron_right, size: 15, color: _ink),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              _weekdayHeader(),
              const SizedBox(height: 9),
              Expanded(child: _monthGrid()),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  'Upcoming',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 27,
                    height: 1,
                    fontWeight: FontWeight.w500,
                    color: _ink,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 24)),
                child: const Text('See all', style: TextStyle(fontSize: 10, color: _muted)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        ..._upcomingRows(),
      ],
    );
  }

  Widget _weekdayHeader() {
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Row(
      children: days.map((day) {
        return Expanded(
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 8,
              color: _muted,
              fontWeight: FontWeight.w500,
              letterSpacing: .2,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _monthGrid() {
    final first = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final leading = first.weekday % 7;
    final days = DateUtils.getDaysInMonth(_visibleMonth.year, _visibleMonth.month);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 42,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisExtent: 53,
      ),
      itemBuilder: (context, index) {
        final value = index - leading + 1;
        if (value < 1 || value > days) return const SizedBox.shrink();

        final day = DateTime(_visibleMonth.year, _visibleMonth.month, value);
        final selected = _sameDay(day, _selected);
        final dots = _dotsFor(day);

        return GestureDetector(
          onTap: () => setState(() => _selected = day),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? _active : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$value',
                  style: TextStyle(
                    color: selected ? Colors.white : _ink,
                    fontSize: 10.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dots.take(3).map((color) {
                    return Container(
                      width: 3,
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 1.1),
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Color> _dotsFor(DateTime day) {
    final real = _entriesFor(day)
        .map((e) => _typeColors[e.type] ?? _muted)
        .toList();
    if (real.isNotEmpty) return real;

    if (_visibleMonth.year == 2026 && _visibleMonth.month == 8) {
      const demo = <int, List<Color>>{
        1: [Color(0xFFD1A7B0), Color(0xFF90A999), Color(0xFFAAA4C1)],
        4: [Color(0xFF90A999), Color(0xFFAAA4C1)],
        5: [Color(0xFFC9A862)],
        9: [Color(0xFFAAA4C1), Color(0xFF90A999)],
        10: [Color(0xFFC59A8B)],
        14: [Color(0xFFD1A7B0), Color(0xFFAAA4C1)],
        17: [Color(0xFF90A999)],
        19: [Color(0xFFC9A862)],
        22: [Color(0xFFAAA4C1), Color(0xFFD1A7B0)],
        25: [Color(0xFFAAA4C1), Color(0xFF90A999)],
        26: [Color(0xFFD1A7B0), Color(0xFF90A999)],
        28: [Color(0xFF90A999), Color(0xFFD1A7B0)],
        30: [Color(0xFFAAA4C1)],
      };
      return demo[day.day] ?? const [];
    }
    return const [];
  }

  List<Widget> _upcomingRows() {
    final actual = _entries.where((e) => !e.start.isBefore(DateTime.now())).toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    if (actual.isNotEmpty) {
      return actual.take(3).map((e) => _eventRow(
        time: DateFormat('h:mm').format(e.start),
        meridiem: DateFormat('a').format(e.start),
        title: e.title,
        color: _typeColors[e.type] ?? _muted,
        onTap: () => _showEntrySheet(existing: e),
      )).toList();
    }

    return [
      _eventRow(time: '9:00', meridiem: 'AM', title: 'Coffee with Sarah', color: const Color(0xFFCBA3AD)),
      _eventRow(time: '11:30', meridiem: 'AM', title: 'Team Sync', color: const Color(0xFF9BB09F)),
      _eventRow(time: '7:00', meridiem: 'PM', title: 'Dinner at Palma', color: const Color(0xFFA9A2BC)),
    ];
  }

  Widget _eventRow({
    required String time,
    required String meridiem,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _rule, width: .7)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: const TextStyle(fontSize: 11, color: _ink)),
                  Text(meridiem, style: const TextStyle(fontSize: 8, color: _muted)),
                ],
              ),
            ),
            Container(width: 3, height: 33, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _ink),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dayView() {
    final items = _entriesFor(_selected);
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
      children: [
        Text(DateFormat('EEEE').format(_selected), style: const TextStyle(fontSize: 10, color: _muted)),
        const SizedBox(height: 4),
        Text(DateFormat('MMMM d').format(_selected), style: GoogleFonts.cormorantGaramond(fontSize: 34, color: _ink)),
        const SizedBox(height: 22),
        if (items.isEmpty)
          const Text('Nothing scheduled.', style: TextStyle(color: _muted, fontSize: 12))
        else
          ...items.map((e) => _eventRow(
                time: DateFormat('h:mm').format(e.start),
                meridiem: DateFormat('a').format(e.start),
                title: e.title,
                color: _typeColors[e.type] ?? _muted,
                onTap: () => _showEntrySheet(existing: e),
              )),
      ],
    );
  }

  Widget _weekView() {
    final start = _selected.subtract(Duration(days: _selected.weekday % 7));
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 18, 10, 16),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(18)),
          child: Row(
            children: List.generate(7, (i) {
              final day = start.add(Duration(days: i));
              final selected = _sameDay(day, _selected);
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selected = day),
                  child: Column(
                    children: [
                      Text(DateFormat('E').format(day).substring(0, 1), style: const TextStyle(fontSize: 9, color: _muted)),
                      const SizedBox(height: 8),
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? _active : Colors.transparent),
                        child: Text('${day.day}', style: TextStyle(fontSize: 10, color: selected ? Colors.white : _ink)),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _yearView() {
    final year = _visibleMonth.year;
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: .9,
      ),
      itemBuilder: (context, index) {
        final month = DateTime(year, index + 1);
        return GestureDetector(
          onTap: () => setState(() {
            _visibleMonth = month;
            _mode = CalendarMode.month;
          }),
          child: Container(
            decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: Text(DateFormat('MMM').format(month), style: GoogleFonts.cormorantGaramond(fontSize: 18, color: _ink)),
          ),
        );
      },
    );
  }

  void _shiftMonth(int amount) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + amount, 1);
      _selected = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    });
  }

  void _showOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Calendar options', style: TextStyle(color: _ink, fontSize: 15)),
        ),
      ),
    );
  }

  Future<void> _showEntrySheet({CalendarEntry? existing}) async {
    final title = TextEditingController(text: existing?.title ?? '');
    DateTime start = existing?.start ?? DateTime(_selected.year, _selected.month, _selected.day, 9);
    String type = existing?.type ?? 'Task';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(22, 22, 22, MediaQuery.of(context).viewInsets.bottom + 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Title', border: InputBorder.none),
                ),
                DropdownButtonFormField<String>(
                  value: type,
                  items: _typeColors.keys.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setSheetState(() => type = v ?? type),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: _active, foregroundColor: Colors.white),
                    onPressed: () {
                      if (title.text.trim().isEmpty) return;
                      final entry = CalendarEntry(
                        id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                        title: title.text.trim(),
                        start: start,
                        end: start.add(const Duration(hours: 1)),
                        type: type,
                      );
                      setState(() {
                        if (existing != null) {
                          final index = _entries.indexWhere((e) => e.id == existing.id);
                          if (index >= 0) _entries[index] = entry;
                        } else {
                          _entries.add(entry);
                        }
                      });
                      _save();
                      Navigator.pop(sheetContext);
                    },
                    child: Text(existing == null ? 'Add event' : 'Save changes'),
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
