import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const _paper = Color(0xFFF6F2EC);
const _ink = Color(0xFF1E1D1A);
const _muted = Color(0xFF746F68);
const _rule = Color(0xFFE3DDD5);
const _soft = Color(0xFFECE6DE);
const _sage = Color(0xFF6D7B68);
const _sand = Color(0xFFC1AA7A);
const _clay = Color(0xFFC97750);

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  DateTime _selected = DateTime(2025, 5, 14);
  final List<_Entry> _entries = [
    _Entry('Design Review', DateTime(2025, 5, 14, 10), DateTime(2025, 5, 14, 11), 'Product', _sage),
    _Entry('Project Kickoff', DateTime(2025, 5, 14, 13), DateTime(2025, 5, 14, 14, 30), 'Client', _sand),
    _Entry('Client Call', DateTime(2025, 5, 14, 16), DateTime(2025, 5, 14, 17), 'Strategy', _clay),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomeView(selected: _selected, entries: _entries, onOpenMonth: () => setState(() => _index = 1), onOpenEntry: _openDetails),
      _MonthView(selected: _selected, entries: _entries, onSelected: (d) => setState(() => _selected = d), onOpenDay: () => setState(() => _index = 2), onOpenEntry: _openDetails),
      _DayView(selected: _selected, entries: _entries, onOpenEntry: _openDetails),
      _InsightsView(entries: _entries),
      _WeekView(selected: _selected, entries: _entries, onOpenEntry: _openDetails),
      _TasksView(selected: _selected, entries: _entries),
    ];

    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      bottomNavigationBar: _BottomBar(
        index: _index,
        onTap: (value) => setState(() => _index = value),
        onAdd: _quickAdd,
      ),
    );
  }

  void _openDetails(_Entry entry) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => _EventDetails(entry: entry)));
  }

  Future<void> _quickAdd() async {
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 80),
          padding: EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.of(context).viewInsets.bottom + 24),
          decoration: const BoxDecoration(
            color: Color(0xFF26231F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white70))),
                const Spacer(),
                const Text('New Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFF5C5750), foregroundColor: Colors.white),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        _entries.add(_Entry(controller.text.trim(), DateTime(_selected.year, _selected.month, _selected.day, 9), DateTime(_selected.year, _selected.month, _selected.day, 10), 'Personal', _sand));
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Create'),
                )
              ]),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: const Color(0xFF4A4540), borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Coffee with Sam tomorrow at 9am',
                    hintStyle: TextStyle(color: Colors.white60),
                    suffixIcon: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFF37332F), borderRadius: BorderRadius.circular(18)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Coffee with Sam', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(DateFormat('EEE, MMM d  •  h:mm a').format(_selected), style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  const SizedBox(height: 10),
                  const Wrap(spacing: 7, children: [
                    _DarkChip('Personal'),
                    _DarkChip('Coffee Shop'),
                  ]),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.selected, required this.entries, required this.onOpenMonth, required this.onOpenEntry});
  final DateTime selected;
  final List<_Entry> entries;
  final VoidCallback onOpenMonth;
  final ValueChanged<_Entry> onOpenEntry;

  @override
  Widget build(BuildContext context) {
    final dayEntries = entries.where((e) => _sameDay(e.start, selected)).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      children: [
        Row(children: [
          Container(width: 20, height: 20, decoration: BoxDecoration(border: Border.all(color: _ink, width: 1.4), shape: BoxShape.circle)),
          const SizedBox(width: 7),
          const Text('ciantis', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const Spacer(),
          CircleAvatar(radius: 17, backgroundColor: const Color(0xFFD5CEC5), child: Icon(Icons.person_rounded, size: 19, color: Colors.grey.shade800)),
        ]),
        const SizedBox(height: 34),
        Text('Good morning,\nAlex', style: GoogleFonts.cormorantGaramond(fontSize: 31, height: 0.95, fontWeight: FontWeight.w500, color: _ink)),
        const SizedBox(height: 8),
        const Text('A focused day\nbuilds an extraordinary week.', style: TextStyle(fontSize: 12, height: 1.35, color: _muted)),
        const SizedBox(height: 23),
        GestureDetector(
          onTap: onOpenMonth,
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
            decoration: BoxDecoration(color: const Color(0xFFFBF8F4), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 16, offset: Offset(0, 8))]),
            child: Column(children: [
              Row(children: [
                const Icon(Icons.chevron_left, size: 18),
                const SizedBox(width: 3),
                Text(DateFormat('MMM yyyy').format(selected).toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .4)),
                const Spacer(),
                const Icon(Icons.chevron_left, size: 16),
                const Icon(Icons.chevron_right, size: 16),
              ]),
              const SizedBox(height: 10),
              _MiniCalendar(selected: selected),
            ]),
          ),
        ),
        const SizedBox(height: 18),
        Row(children: [
          Text('Today · ${DateFormat('EEE, MMM d').format(selected)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const Spacer(),
          _Pill('${dayEntries.length} events'),
        ]),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: const Color(0xFFFBF8F4), borderRadius: BorderRadius.circular(18), border: Border.all(color: _rule)),
          child: Column(children: dayEntries.map((entry) => _AgendaRow(entry: entry, onTap: () => onOpenEntry(entry))).toList()),
        ),
      ],
    );
  }
}

class _MonthView extends StatelessWidget {
  const _MonthView({required this.selected, required this.entries, required this.onSelected, required this.onOpenDay, required this.onOpenEntry});
  final DateTime selected;
  final List<_Entry> entries;
  final ValueChanged<DateTime> onSelected;
  final VoidCallback onOpenDay;
  final ValueChanged<_Entry> onOpenEntry;

  @override
  Widget build(BuildContext context) {
    final selectedEntries = entries.where((e) => _sameDay(e.start, selected)).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      children: [
        Row(children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
          Expanded(child: Center(child: Text(DateFormat('MMMM yyyy').format(selected), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)))),
          _RoundIcon(Icons.format_list_bulleted_rounded),
        ]),
        const SizedBox(height: 13),
        _LargeCalendar(selected: selected, onSelected: onSelected),
        const SizedBox(height: 24),
        Container(
          height: 118,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF2EEE8), Color(0xFFD8D0C5)])),
          child: Align(alignment: Alignment.topLeft, child: Text('Plans\nturn into progress.', style: GoogleFonts.cormorantGaramond(fontSize: 22, height: .95, color: _ink))),
        ),
        Transform.translate(
          offset: const Offset(0, -18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            decoration: const BoxDecoration(color: _paper, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(DateFormat('EEE, MMM d').format(selected).toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .5)),
              const SizedBox(height: 10),
              ...selectedEntries.map((e) => _AgendaRow(entry: e, onTap: () => onOpenEntry(e))),
              const SizedBox(height: 2),
              Align(alignment: Alignment.centerRight, child: TextButton(onPressed: onOpenDay, child: const Text('Open day', style: TextStyle(color: _ink)))),
            ]),
          ),
        ),
      ],
    );
  }
}

class _DayView extends StatelessWidget {
  const _DayView({required this.selected, required this.entries, required this.onOpenEntry});
  final DateTime selected;
  final List<_Entry> entries;
  final ValueChanged<_Entry> onOpenEntry;

  @override
  Widget build(BuildContext context) {
    final dayEntries = entries.where((e) => _sameDay(e.start, selected)).toList();
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(children: [
          const Icon(Icons.chevron_left),
          Expanded(child: Center(child: Text(DateFormat('EEE, MMM d').format(selected), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)))),
          const Icon(Icons.calendar_today_outlined, size: 18),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 8),
        child: Align(alignment: Alignment.centerLeft, child: Text('Same 24 hours.\nA more intentional you.', style: GoogleFonts.cormorantGaramond(fontSize: 21, height: 1.0, color: _muted))),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
          itemCount: 13,
          itemBuilder: (context, i) {
            final hour = 8 + i;
            final matching = dayEntries.where((e) => e.start.hour == hour).toList();
            return SizedBox(
              height: 62,
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 42, child: Text(DateFormat('h a').format(DateTime(2025, 1, 1, hour)), style: const TextStyle(fontSize: 10, color: _muted))),
                Expanded(
                  child: Stack(children: [
                    const Positioned(left: 0, right: 0, top: 6, child: Divider(height: 1, color: _rule)),
                    if (matching.isNotEmpty)
                      Positioned(
                        left: 6,
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => onOpenEntry(matching.first),
                          child: _TimeBlock(entry: matching.first),
                        ),
                      ),
                  ]),
                ),
              ]),
            );
          },
        ),
      ),
    ]);
  }
}

class _InsightsView extends StatelessWidget {
  const _InsightsView({required this.entries});
  final List<_Entry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(20, 20, 20, 20), children: [
      Row(children: [const Icon(Icons.chevron_left), const Spacer(), const Text('This Week', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)), const Spacer(), const Icon(Icons.chevron_right)]),
      const Center(child: Text('May 12 – May 18', style: TextStyle(fontSize: 11, color: _muted))),
      const SizedBox(height: 22),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.35,
        children: const [
          _MetricCard('12', 'Total events', '↗ 20%'),
          _MetricCard('7h 30m', 'Focused work', '↗ 12%'),
          _MetricCard('3', 'Client meetings', '→ same'),
          _MetricCard('2', 'Deep work blocks', '↗ 100%'),
        ],
      ),
      const SizedBox(height: 12),
      Container(
        height: 178,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: const LinearGradient(colors: [Color(0xFFE9DED0), Color(0xFFD3C8B9)])),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('INSIGHT', style: TextStyle(fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w700, color: _muted)),
          const SizedBox(height: 6),
          Text("You're building\nmomentum.", style: GoogleFonts.cormorantGaramond(fontSize: 25, height: .95)),
          const SizedBox(height: 6),
          const Text('3 focused days in a row.', style: TextStyle(fontSize: 11, color: _muted)),
          const Spacer(),
          Align(alignment: Alignment.bottomRight, child: CircleAvatar(backgroundColor: _ink, child: const Icon(Icons.arrow_forward, color: Colors.white))),
        ]),
      ),
    ]);
  }
}

class _WeekView extends StatelessWidget {
  const _WeekView({required this.selected, required this.entries, required this.onOpenEntry});
  final DateTime selected;
  final List<_Entry> entries;
  final ValueChanged<_Entry> onOpenEntry;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Row(children: [
          Expanded(child: Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(color: _soft, borderRadius: BorderRadius.circular(18)), child: Row(children: const [Expanded(child: _Segment('Month', false)), Expanded(child: _Segment('Week', true)), Expanded(child: _Segment('Day', false))]))),
          const SizedBox(width: 12),
          _RoundIcon(Icons.tune_rounded),
        ]),
      ),
      const SizedBox(height: 6),
      Text(DateFormat('MMMM yyyy').format(selected), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 10),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('S\n11', textAlign: TextAlign.center), Text('M\n12', textAlign: TextAlign.center), Text('T\n13', textAlign: TextAlign.center), Text('W\n14', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)), Text('T\n15', textAlign: TextAlign.center), Text('F\n16', textAlign: TextAlign.center), Text('S\n17', textAlign: TextAlign.center)])),
      const SizedBox(height: 8),
      Expanded(child: _DayView(selected: selected, entries: entries, onOpenEntry: onOpenEntry)),
    ]);
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView({required this.selected, required this.entries});
  final DateTime selected;
  final List<_Entry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 20), children: [
      Row(children: [const Icon(Icons.menu_rounded), const Spacer(), Text(DateFormat('MMMM yyyy').format(selected), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), const Spacer(), const Icon(Icons.search), const SizedBox(width: 14), const Icon(Icons.settings_outlined)]),
      const SizedBox(height: 18),
      _MiniCalendar(selected: selected),
      const SizedBox(height: 18),
      Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: _soft, borderRadius: BorderRadius.circular(19)), child: const Row(children: [Expanded(child: _Segment('Events', true)), Expanded(child: _Segment('Tasks', false))])),
      const SizedBox(height: 18),
      Text('Today · ${DateFormat('EEE, MMM d').format(selected)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      const SizedBox(height: 12),
      const _TaskRow('Send deck to client', '9:00 AM', true),
      ...entries.map((e) => _AgendaRow(entry: e, onTap: () {})),
      const SizedBox(height: 16),
      const Divider(color: _rule),
      const SizedBox(height: 8),
      const Text('Tomorrow · Thu, May 15', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      const SizedBox(height: 12),
      const _TaskRow('Follow up with Jamie', '9:00 AM', false),
      const SizedBox(height: 26),
      Text('Better planning.\nA calmer, more intentional you.', style: GoogleFonts.cormorantGaramond(fontSize: 18, height: .95, color: _muted)),
    ]);
  }
}

class _EventDetails extends StatelessWidget {
  const _EventDetails({required this.entry});
  final _Entry entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paper,
      body: SafeArea(
        child: Column(children: [
          Container(
            height: 155,
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF596252), Color(0xFF31372F)]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(72)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(backgroundColor: Colors.white24, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white))),
                const Spacer(),
                const CircleAvatar(backgroundColor: Colors.white24, child: Icon(Icons.more_horiz, color: Colors.white)),
              ]),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 14),
                decoration: const BoxDecoration(color: _paper, borderRadius: BorderRadius.vertical(top: Radius.circular(44))),
                child: ListView(children: [
                  Row(children: [Container(width: 7, height: 7, decoration: BoxDecoration(color: entry.color, shape: BoxShape.circle)), const SizedBox(width: 6), Text('WORK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: entry.color))]),
                  const SizedBox(height: 12),
                  Text(entry.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text('${entry.category} · ${entry.durationLabel}', style: const TextStyle(fontSize: 12, color: _muted)),
                  const SizedBox(height: 18),
                  const Row(children: [CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)), SizedBox(width: 5), CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)), SizedBox(width: 5), CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)), SizedBox(width: 5), _Pill('+2')]),
                  const SizedBox(height: 18),
                  _DetailRow(Icons.calendar_today_outlined, DateFormat('EEE, MMM d, yyyy').format(entry.start), '${DateFormat('h:mm').format(entry.start)} – ${DateFormat('h:mm a').format(entry.end)}'),
                  const _DetailRow(Icons.location_on_outlined, 'Zoom', 'https://zoom.us/ciantis/review'),
                  const _DetailRow(Icons.description_outlined, 'Design Review Notes', 'Figma · Updated 2h ago'),
                  const SizedBox(height: 16),
                  const Text('Review latest designs, align on feedback,\nand confirm next steps for the Q2 release.', style: TextStyle(fontSize: 12, height: 1.45)),
                  const SizedBox(height: 22),
                  const Text('ATTENDEES', style: TextStyle(fontSize: 10, color: _muted, fontWeight: FontWeight.w700, letterSpacing: .8)),
                  const SizedBox(height: 10),
                  const _Attendee('Alex Morgan', 'Product Lead', 'Organizer'),
                  const _Attendee('Jamie Park', 'Design', 'Going'),
                  const _Attendee('Taylor Kim', 'Engineering', 'Going'),
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
            child: Row(children: [
              Expanded(child: OutlinedButton(style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: const StadiumBorder(), side: const BorderSide(color: _rule)), onPressed: () {}, child: const Text('Edit', style: TextStyle(color: _ink)))),
              const SizedBox(width: 10),
              Expanded(child: FilledButton(style: FilledButton.styleFrom(backgroundColor: _ink, padding: const EdgeInsets.symmetric(vertical: 15), shape: const StadiumBorder()), onPressed: () {}, child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.videocam, size: 17), SizedBox(width: 7), Text('Join')]))),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.index, required this.onTap, required this.onAdd});
  final int index;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(color: _paper, border: Border(top: BorderSide(color: _rule))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _NavItem(Icons.home_filled, 'Home', index == 0, () => onTap(0)),
          _NavItem(Icons.calendar_today_outlined, 'Calendar', index == 1 || index == 2 || index == 4, () => onTap(1)),
          GestureDetector(onTap: onAdd, child: Container(width: 43, height: 43, decoration: const BoxDecoration(color: _ink, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white, size: 24))),
          _NavItem(Icons.check_box_outlined, 'Tasks', index == 5, () => onTap(5)),
          _NavItem(Icons.more_horiz, 'More', index == 3, () => onTap(3)),
        ]),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(this.icon, this.label, this.active, this.onTap);
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, child: SizedBox(width: 56, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 19, color: active ? _ink : _muted), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 8, color: active ? _ink : _muted, fontWeight: active ? FontWeight.w700 : FontWeight.w500))])));
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar({required this.selected});
  final DateTime selected;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(selected.year, selected.month, 1);
    final offset = first.weekday % 7;
    final days = DateUtils.getDaysInMonth(selected.year, selected.month);
    return Column(children: [
      const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Text('S', style: _calLabel), Text('M', style: _calLabel), Text('T', style: _calLabel), Text('W', style: _calLabel), Text('T', style: _calLabel), Text('F', style: _calLabel), Text('S', style: _calLabel)]),
      const SizedBox(height: 7),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.4),
        itemCount: 42,
        itemBuilder: (context, i) {
          final day = i - offset + 1;
          if (day < 1 || day > days) return const SizedBox.shrink();
          final selectedDay = day == selected.day;
          return Center(child: Container(width: 27, height: 27, alignment: Alignment.center, decoration: selectedDay ? const BoxDecoration(color: _ink, shape: BoxShape.circle) : null, child: Text('$day', style: TextStyle(fontSize: 10, fontWeight: selectedDay ? FontWeight.w700 : FontWeight.w500, color: selectedDay ? Colors.white : _ink))));
        },
      )
    ]);
  }
}

const _calLabel = TextStyle(fontSize: 9, color: _muted, fontWeight: FontWeight.w600);

class _LargeCalendar extends StatelessWidget {
  const _LargeCalendar({required this.selected, required this.onSelected});
  final DateTime selected;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(selected.year, selected.month, 1);
    final offset = first.weekday % 7;
    final days = DateUtils.getDaysInMonth(selected.year, selected.month);
    return Column(children: [
      const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Text('S', style: _calLabel), Text('M', style: _calLabel), Text('T', style: _calLabel), Text('W', style: _calLabel), Text('T', style: _calLabel), Text('F', style: _calLabel), Text('S', style: _calLabel)]),
      const SizedBox(height: 9),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisExtent: 43),
        itemCount: 42,
        itemBuilder: (context, i) {
          final day = i - offset + 1;
          if (day < 1 || day > days) return const SizedBox.shrink();
          final isSelected = day == selected.day;
          return GestureDetector(
            onTap: () => onSelected(DateTime(selected.year, selected.month, day)),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 32, height: 32, alignment: Alignment.center, decoration: isSelected ? const BoxDecoration(color: _ink, shape: BoxShape.circle) : null, child: Text('$day', style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600, color: isSelected ? Colors.white : _ink))),
              if ([4, 5, 12, 14, 15, 17, 20, 22, 30].contains(day)) Container(width: 3, height: 3, margin: const EdgeInsets.only(top: 2), decoration: const BoxDecoration(color: _clay, shape: BoxShape.circle)),
            ])),
          );
        },
      )
    ]);
  }
}

class _AgendaRow extends StatelessWidget {
  const _AgendaRow({required this.entry, required this.onTap});
  final _Entry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _rule))),
        child: Row(children: [
          SizedBox(width: 63, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(DateFormat('h:mm a').format(entry.start), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)), Text(entry.durationLabel, style: const TextStyle(fontSize: 9, color: _muted))])),
          Container(width: 6, height: 6, decoration: BoxDecoration(color: entry.color, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entry.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), Text('${entry.category} · ${entry.durationLabel}', style: const TextStyle(fontSize: 9, color: _muted))])),
          const Icon(Icons.chevron_right, size: 18, color: _muted),
        ]),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({required this.entry});
  final _Entry entry;

  @override
  Widget build(BuildContext context) => Container(
    height: 55,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(color: entry.color.withOpacity(.18), borderRadius: BorderRadius.circular(8), border: Border(left: BorderSide(color: entry.color, width: 2))),
    child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(entry.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), Text('${DateFormat('h:mm').format(entry.start)} – ${DateFormat('h:mm a').format(entry.end)}', style: const TextStyle(fontSize: 9, color: _muted))])), Icon(entry.category == 'Strategy' ? Icons.call_outlined : Icons.videocam_outlined, size: 15, color: entry.color)]),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard(this.value, this.label, this.delta);
  final String value;
  final String label;
  final String delta;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFBF8F4), borderRadius: BorderRadius.circular(18), border: Border.all(color: _rule)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: GoogleFonts.cormorantGaramond(fontSize: 28, height: 1)), const Spacer(), Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)), const SizedBox(height: 3), Text(delta, style: const TextStyle(fontSize: 9, color: _muted))]));
}

class _TaskRow extends StatelessWidget {
  const _TaskRow(this.title, this.time, this.done);
  final String title;
  final String time;
  final bool done;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 9), child: Row(children: [Icon(done ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, size: 19, color: done ? _sage : _muted), const SizedBox(width: 9), Expanded(child: Text(title, style: const TextStyle(fontSize: 11))), Text(time, style: const TextStyle(fontSize: 9, color: _muted))]));
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 18), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 10, color: _muted))]))]));
}

class _Attendee extends StatelessWidget {
  const _Attendee(this.name, this.role, this.status);
  final String name;
  final String role;
  final String status;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), Text(role, style: const TextStyle(fontSize: 9, color: _muted))])), _Pill(status)]));
}

class _Pill extends StatelessWidget {
  const _Pill(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: _soft, borderRadius: BorderRadius.circular(20)), child: Text(label, style: const TextStyle(fontSize: 9, color: _muted, fontWeight: FontWeight.w600)));
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon(this.icon);
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(width: 34, height: 34, decoration: BoxDecoration(color: _soft, borderRadius: BorderRadius.circular(14)), child: Icon(icon, size: 17));
}

class _Segment extends StatelessWidget {
  const _Segment(this.label, this.active);
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 7), decoration: BoxDecoration(color: active ? _ink : Colors.transparent, borderRadius: BorderRadius.circular(15)), child: Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: active ? Colors.white : _ink, fontWeight: FontWeight.w600)));
}

class _DarkChip extends StatelessWidget {
  const _DarkChip(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)), child: Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)));
}

class _Entry {
  _Entry(this.title, this.start, this.end, this.category, this.color);
  final String title;
  final DateTime start;
  final DateTime end;
  final String category;
  final Color color;

  String get durationLabel {
    final minutes = end.difference(start).inMinutes;
    if (minutes % 60 == 0) return '${minutes ~/ 60}h';
    return '${minutes / 60}h';
  }
}

bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
