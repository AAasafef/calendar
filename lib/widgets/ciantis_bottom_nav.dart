import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CiantisBottomNav extends StatelessWidget {
  const CiantisBottomNav({super.key, required this.currentIndex, required this.onTap, required this.onAdd});
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF24221F);
    const muted = Color(0xFF8C867E);
    const paper = Color(0xFFF4F0E9);
    return Material(
      color: paper,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 74,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(0, CupertinoIcons.house, 'Home', ink, muted),
              _item(1, CupertinoIcons.calendar, 'Calendar', ink, muted),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(color: ink, shape: BoxShape.circle),
                  child: const Icon(CupertinoIcons.add, color: Colors.white, size: 22),
                ),
              ),
              _item(3, CupertinoIcons.checkmark_square, 'Tasks', ink, muted),
              _item(4, CupertinoIcons.ellipsis, 'More', ink, muted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(int index, IconData icon, String label, Color ink, Color muted) {
    final active = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, active ? -3 : 0),
              child: Icon(icon, size: 20, color: active ? ink : muted),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 8.5, color: active ? ink : muted, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
