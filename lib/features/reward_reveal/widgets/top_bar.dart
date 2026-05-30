import 'package:flutter/material.dart';

import 'glass_icon_button.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          tooltip: 'Back',
          onPressed: () {},
        ),
        const Spacer(),
        GlassIconButton(
          icon: Icons.settings_rounded,
          tooltip: 'Settings',
          onPressed: () {},
        ),
      ],
    );
  }
}
