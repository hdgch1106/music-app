import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/downloads/presentation/presentation.dart';
import 'package:music_app/features/music/presentation/presentation.dart';

class DownloadsView extends ConsumerWidget {
  const DownloadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final musicFolderPv = ref.watch(musicFolderProvider);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),
            const TopTitleDownload(),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: musicFolderPv.playlist.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No hay música",
                            style: getSubtitleStyle(),
                          ),
                          SizedBox(height: size.height * 0.02),
                          ElevatedButton(
                            onPressed: () => ref
                                .read(musicFolderProvider.notifier)
                                .setMusicFolder(),
                            child: Text(
                              "Seleccionar carpeta",
                              style: getSubtitleStyle().copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const MusicsVerticalDownloads(),
            ),
          ],
        ),
      ),
    );
  }
}
