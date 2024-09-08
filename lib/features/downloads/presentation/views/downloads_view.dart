import 'package:flutter/material.dart';
import 'package:music_app/features/downloads/presentation/presentation.dart';

class DownloadsView extends StatelessWidget {
  const DownloadsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),
            const TopTitleDownload(),
            SizedBox(height: size.height * 0.03),
            const MusicsVerticalDownloads(),
          ],
        ),
      ),
    );
  }
}
