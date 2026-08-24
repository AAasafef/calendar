import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/ciantis_theme.dart';

/// Bottom bar matching the reference: Home · Calendar · (raised + button) ·
/// Tasks · More, with small labels under each tab and a floating dark
/// circular button for quick-add sitting above the bar.
class CiantisBottomNav extends StatelessWidget {
  const CiantisBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  final int currentIndex; // 0 Home, 1 Calendar, 2 Tasks, 3 More
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;

  // Icons chosen from the set already used elsewhere in this codebase
  // (Icons.home_*, CupertinoIcons.calendar, Icons.checklist and
  // CupertinoIcons.ellipsis all appear pre-existing in this app), to avoid
  // referencing a glyph name that isn't in this project's icon font.
  static const _items = <(IconData, String)>[
    (Icons.home_rounded, 'Home'),
    (CupertinoIcons.calendar, 'Calendar'),
    (Icons.checklist, 'Tasks'),
    (CupertinoIcons.ellipsis, 'More'),
  ];

  Widget _tab(int index) {
    final active = currentIndex == index;
    final (icon, label) = _items[index];
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: active ? 24 : 21, color: active ? CiantisColors.ink : CiantisColors.muted),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? CiantisColors.ink : CiantisColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: CiantisColors.card,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 62,
                  child: Row(
                    children: [
                      _tab(0),
                      _tab(1),
                      const SizedBox(width: 56),
                      _tab(2),
                      _tab(3),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: CiantisColors.ink,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: CiantisColors.ink.withOpacity(0.28), blurRadius: 14, offset: const Offset(0, 6)),
                  ],
                ),
                child: const Icon(CupertinoIcons.add, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
