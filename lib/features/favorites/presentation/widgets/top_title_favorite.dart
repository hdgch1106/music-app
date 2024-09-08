import 'package:flutter/material.dart';
import 'package:music_app/core/core.dart';

class TopTitleFavorite extends StatelessWidget {
  const TopTitleFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideInText(
          text: "Aqui tienes",
          style: getHeaderStyle(),
        ),
        SlideInText(
          text: "tus favoritos",
          style: getHeaderStyle().copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
