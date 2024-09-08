import 'package:flutter/material.dart';
import 'package:music_app/core/core.dart';

class TopTitleDownload extends StatelessWidget {
  const TopTitleDownload({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Aqui tienes",
          style: getHeaderStyle(),
        ),
        Text(
          "tus descargas",
          style: getHeaderStyle().copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
