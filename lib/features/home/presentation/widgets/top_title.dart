import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/account/presentation/presentation.dart';

class TopTitle extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userPv = ref.watch(userProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideInText(
          text: getGreeting(),
          style: getHeaderStyle(),
        ),
        SlideInText(
          text: userPv.fullName,
          style: getHeaderStyle().copyWith(
            color: theme.colorScheme.secondary,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
