import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ciantis_theme.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  static const _rows = <(IconData, String)>[
    (CupertinoIcons.paintbrush, 'Appearance'),
    (CupertinoIcons.bell, 'Notifications'),
    (CupertinoIcons.arrow_2_circlepath, 'Sync & backup'),
    (CupertinoIcons.info_circle, 'About CIANTIS'),
  ];

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
                'More',
                style: GoogleFonts.cormorantGaramond(fontSize: 30, fontWeight: FontWeight.w500, color: CiantisColors.ink),
              ),
              const SizedBox(height: 16),
              ..._rows.map((row) {
                final (icon, label) = row;
                return Container(
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: CiantisColors.rule, width: .7))),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(icon, size: 19, color: CiantisColors.active),
                    title: Text(label, style: const TextStyle(fontSize: 13, color: CiantisColors.ink)),
                    trailing: const Icon(CupertinoIcons.chevron_right, size: 14, color: CiantisColors.muted),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
