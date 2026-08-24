import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/calendar_entry.dart';
import '../services/calendar_store.dart';
import '../theme/ciantis_theme.dart';

/// "01 / At a glance" — greeting, a compact month calendar, and today's
/// events, mirroring the reference home screen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.userName = 'there'});

  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarStore _store = CalendarStore();
  DateTime _visibleMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  final DateTime _today = DateTime.now();
  List<CalendarEntry> _entries = [];

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

  bool _sameDay(DateTime a, DateTime b) => DateUtils.isSameDay(a, b);

  List<CalendarEntry> _entriesFor(DateTime day) {
    final result = _entries.where((e) => _sameDay(e.start, day)).toList();
    result.sort((a, b) => a.start.compareTo(b.start));
    return result;
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final todays = _entriesFor(_today);

    return Scaffold(
      backgroundColor: CiantisColors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
          children: [
            _topBar(),
            const SizedBox(height: 26),
            Text(
              '${_greeting()},',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 30,
                height: 1.05,
                fontWeight: FontWeight.w500,
                color: CiantisColors.ink,
              ),
            ),
            Text(
              widget.userName,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 30,
                height: 1.1,
                fontWeight: FontWeight.w500,
                color: CiantisColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              todays.isEmpty ? 'A clear day. Make it a good one.' : 'A focused day builds an extraordinary week.',
              style: const TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: CiantisColors.muted),
            ),
            const SizedBox(height: 22),
            _miniCalendarCard(),
            const SizedBox(height: 26),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Today · ${DateFormat('EEE, MMM d').format(_today)}',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: CiantisColors.ink,
                    ),
                  ),
                ),
                Text(
                  '${todays.length} event${todays.length == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 10.5, color: CiantisColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (todays.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('Nothing scheduled today.', style: TextStyle(color: CiantisColors.muted, fontSize: 12)),
              )
            else
              ...todays.map(_eventRow),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: CiantisColors.active, borderRadius: BorderRadius.circular(9)),
          child: const Text('C', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 9),
        Text(
          'ciantis',
          style: GoogleFonts.cormorantGaramond(fontSize: 18, fontWeight: FontWeight.w600, color: CiantisColors.ink),
        ),
        const Spacer(),
        Container(
          width: 34,
          height: 34,
          decoration: const BoxDecoration(color: CiantisColors.tabFill, shape: BoxShape.circle),
          child: const Icon(CupertinoIcons.person_fill, size: 17, color: CiantisColors.active),
        ),
      ],
    );
  }

  Widget _miniCalendarCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      decoration: BoxDecoration(color: CiantisColors.card, borderRadius: BorderRadius.circular(19)),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(() {
                  _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1, 1);
                }),
                icon: const Icon(CupertinoIcons.chevron_left, size: 14, color: CiantisColors.ink),
              ),
              Expanded(
                child: Text(
                  DateFormat('MMMM yyyy').format(_visibleMonth),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorantGaramond(fontSize: 16, fontWeight: FontWeight.w600, color: CiantisColors.ink),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(() {
                  _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1, 1);
                }),
                icon: const Icon(CupertinoIcons.chevron_right, size: 14, color: CiantisColors.ink),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((d) => Expanded(
                      child: Text(d, textAlign: TextAlign.center, style: const TextStyle(fontSize: 8.5, color: CiantisColors.muted)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 4),
          _grid(),
        ],
      ),
    );
  }

  Widget _grid() {
    final first = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final leading = first.weekday % 7;
    final days = DateUtils.getDaysInMonth(_visibleMonth.year, _visibleMonth.month);
    final rows = ((leading + days) / 7).ceil();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows * 7,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisExtent: 34),
      itemBuilder: (context, index) {
        final value = index - leading + 1;
        if (value < 1 || value > days) return const SizedBox.shrink();

        final day = DateTime(_visibleMonth.year, _visibleMonth.month, value);
        final isToday = _sameDay(day, _today);
        final hasEvents = _entriesFor(day).isNotEmpty;

        return Center(
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: isToday ? CiantisColors.active : Colors.transparent, shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$value',
                  style: TextStyle(
                    color: isToday ? Colors.white : CiantisColors.ink,
                    fontSize: 11,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (hasEvents && !isToday)
                  Positioned(
                    bottom: 2,
                    child: Container(width: 3, height: 3, decoration: const BoxDecoration(color: CiantisColors.accent, shape: BoxShape.circle)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _eventRow(CalendarEntry e) {
    final color = CiantisColors.typeColors[e.type] ?? CiantisColors.muted;
    final duration = e.end.difference(e.start);
    final hours = duration.inMinutes / 60;
    final durationLabel = hours == hours.roundToDouble() ? '${hours.round()}h' : '${hours.toStringAsFixed(1)}h';

    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: CiantisColors.rule, width: .7))),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 46,
        leading: SizedBox(
          width: 46,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('h:mm').format(e.start), style: const TextStyle(fontSize: 11.5, color: CiantisColors.ink)),
              Text(DateFormat('a').format(e.start), style: const TextStyle(fontSize: 8, color: CiantisColors.muted)),
            ],
          ),
        ),
        title: Row(
          children: [
            Container(width: 3, height: 30, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: CiantisColors.ink)),
                  Text('${e.type} · $durationLabel', style: const TextStyle(fontSize: 10.5, color: CiantisColors.muted)),
                ],
              ),
            ),
          ],
        ),
        trailing: const Icon(CupertinoIcons.chevron_right, size: 14, color: CiantisColors.muted),
      ),
    );
  }
}
