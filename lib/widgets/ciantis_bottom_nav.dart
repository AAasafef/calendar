import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CiantisBottomNav extends StatelessWidget {
  const CiantisBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF6C5C50);
    const inactive = Color(0x7A6C5C50);
    const paper = Color(0xFFF6F2EC);

    const icons = <IconData>[
      Icons.auto_awesome_outlined,
      CupertinoIcons.calendar,
      Icons.grid_view_rounded,
      CupertinoIcons.square_pencil,
      CupertinoIcons.gear,
    ];

    return Material(
      color: paper,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(icons.length, (index) {
              final active = currentIndex == index;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: SizedBox(
                  width: 52,
                  height: 54,
                  child: Align(
                    alignment: active ? const Alignment(0, -0.35) : Alignment.center,
                    child: Icon(
                      icons[index],
                      size: active ? 28 : 25,
                      color: active ? ink : inactive,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
