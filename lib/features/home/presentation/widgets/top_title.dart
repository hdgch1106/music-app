import 'package:flutter/material.dart';
import 'package:music_app/core/core.dart';

class TopTitle extends StatelessWidget {
  const TopTitle({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Buenos días,';
    } else if (hour < 18) {
      return 'Buenas tardes,';
    } else {
      return 'Buenas noches,';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getGreeting(),
          style: getHeaderStyle(),
        ),
        Text(
          "Hugo",
          style: getHeaderStyle().copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
