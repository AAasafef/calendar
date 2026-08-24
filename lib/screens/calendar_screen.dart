import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const bg = Color(0xFFF4F0E9);
  static const ink = Color(0xFF25221F);
  static const muted = Color(0xFF8D867F);
  static const sage = Color(0xFF899B87);
  static const sand = Color(0xFFB6A27C);
  static const coral = Color(0xFFC9825C);

  DateTime visibleMonth = DateTime(2025, 5, 1);
  DateTime selected = DateTime(2025, 5, 14);

  void shiftMonth(int delta) {
    setState(() {
      visibleMonth = DateTime(visibleMonth.year, visibleMonth.month + delta, 1);
      selected = DateTime(visibleMonth.year, visibleMonth.month, 14);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 8),
            _topBar(),
            const SizedBox(height: 8),
            _calendarGrid(),
            const SizedBox(height: 6),
            _wavePanel(),
            _agendaCard(),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => shiftMonth(-1),
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(CupertinoIcons.chevron_left, size: 18, color: ink),
            ),
          ),
          Expanded(
            child: Text(
              DateFormat('MMMM yyyy').format(visibleMonth),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ink,
                letterSpacing: -0.2,
              ),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE9E3DB),
              shape: BoxShape.circle,
            ),
            child: const Icon(CupertinoIcons.list_bullet, size: 16, color: ink),
          ),
        ],
      ),
    );
  }

  Widget _calendarGrid() {
    final first = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final leading = first.weekday % 7;
    final count = DateUtils.getDaysInMonth(visibleMonth.year, visibleMonth.month);
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 0),
      child: Column(
        children: [
          Row(
            children: labels
                .map((e) => Expanded(
                      child: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9,
                          color: muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 5),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 43,
            ),
            itemBuilder: (context, index) {
              final dayNum = index - leading + 1;
              if (dayNum < 1 || dayNum > count) {
                return const SizedBox.shrink();
              }

              final day = DateTime(visibleMonth.year, visibleMonth.month, dayNum);
              final active = DateUtils.isSameDay(day, selected);
              final dots = _dots(dayNum);

              return GestureDetector(
                onTap: () => setState(() => selected = day),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? ink : Colors.transparent,
                      ),
                      child: Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          color: active ? Colors.white : ink,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dots
                            .map((c) => Container(
                                  width: 3,
                                  height: 3,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Color> _dots(int day) {
    const map = <int, List<Color>>{
      4: [coral],
      5: [coral],
      7: [sage],
      12: [sage],
      14: [sage, sand],
      15: [coral],
      17: [sage],
      20: [sand],
      21: [sage],
      24: [coral],
      26: [sage],
      28: [sand],
      30: [coral],
    };
    return map[day] ?? const [];
  }

  Widget _wavePanel() {
    return SizedBox(
      height: 128,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipPath(
            clipper: _WaveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFD8D1C8), Color(0xFFE8E1DA)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 28,
            bottom: 22,
            child: Text(
              'Plans\nturn into progress.',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 23,
                height: 0.92,
                fontWeight: FontWeight.w500,
                color: ink,
                letterSpacing: -0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _agendaCard() {
    return Transform.translate(
      offset: const Offset(0, -13),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F5F0),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(18, 17, 18, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('EEE, MMM d').format(selected).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.55,
                        color: muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _eventRow('10:00', 'AM', 'Design Review', '1h', sage),
              _eventRow('1:00', 'PM', 'Project Kickoff', '1.5h', sand),
              _eventRow('4:00', 'PM', 'Client Call', '1h', coral, last: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventRow(String time, String meridiem, String title, String duration, Color color, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: Color(0x1425221F), width: 0.8)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: const TextStyle(fontSize: 10.5, color: ink)),
                Text(meridiem, style: const TextStyle(fontSize: 8, color: muted)),
              ],
            ),
          ),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: ink)),
                const SizedBox(height: 2),
                Text(duration, style: const TextStyle(fontSize: 8.5, color: muted)),
              ],
            ),
          ),
          const Icon(CupertinoIcons.chevron_right, size: 12, color: muted),
        ],
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.43);
    path.cubicTo(
      size.width * 0.18,
      size.height * 0.18,
      size.width * 0.33,
      size.height * 0.20,
      size.width * 0.52,
      size.height * 0.40,
    );
    path.cubicTo(
      size.width * 0.73,
      size.height * 0.63,
      size.width * 0.88,
      size.height * 0.61,
      size.width,
      size.height * 0.52,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
