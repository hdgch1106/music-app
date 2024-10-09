import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/music/presentation/presentation.dart';

class MusicScreen extends ConsumerWidget {
  const MusicScreen({super.key});

  //Convert duration into min:sec format
  String _durationToString(Duration duration) {
    String twoDigitsSeconds = duration.inSeconds.remainder(60).toString();
    String formatted = '${duration.inMinutes}:'
        '${twoDigitsSeconds.padLeft(2, '0')}';

    return formatted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicPv = ref.watch(musicProvider);
    final size = MediaQuery.of(context).size;

    final musicUtil = musicPv.playlist[musicPv.currentSongIndex];

    final isFavorite = ref
        .watch(favoriteProvider)
        .savedMusic
        .containsKey(musicUtil.id.toString());

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            /* await ref.read(musicProvider.notifier).stopAndDispose();
            if (!context.mounted) return; */
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(musicUtil.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              musicUtil.name,
                              style: getTitleStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              musicUtil.description,
                              style: getSubtitleStyle().copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(favoriteProvider.notifier)
                              .saveMusic(musicUtil);
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 30,
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 0,
                      ),
                    ),
                    child: Slider(
                      value: musicPv.currentDuration.inSeconds.toDouble(),
                      min: 0,
                      max: musicPv.totalDuration.inSeconds.toDouble(),
                      activeColor: Colors.orange.shade700,
                      inactiveColor: Colors.grey,
                      onChanged: (value) {
                        ref
                            .read(musicProvider.notifier)
                            .audioPlayer
                            .seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  // Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _durationToString(musicPv.currentDuration),
                        style: getSubtitleStyle(),
                      ),
                      Text(
                        _durationToString(musicPv.totalDuration),
                        style: getSubtitleStyle(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous_outlined),
                        onPressed: () {
                          ref.read(musicProvider.notifier).onPlayPrevious();
                        },
                        iconSize: 40,
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(
                          musicPv.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                        ),
                        onPressed: () {
                          ref.read(musicProvider.notifier).onPauseOrResume();
                        },
                        iconSize: 60,
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next_outlined),
                        onPressed: () {
                          ref.read(musicProvider.notifier).onPlayNext();
                        },
                        iconSize: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Botons shuffle, repeat, leters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.format_list_bulleted),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              final playlist = musicPv.playlist;
                              return ListView.builder(
                                itemCount: playlist.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(playlist[index].name),
                                    onTap: () {
                                      ref
                                          .read(musicProvider.notifier)
                                          .setCurrentSongIndex(index);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        iconSize: 20,
                        color: Colors.grey,
                      ),
                      IconButton(
                        icon: Icon(
                          ref
                                      .read(musicProvider.notifier)
                                      .audioPlayer
                                      .loopMode ==
                                  LoopMode.off
                              ? Icons.repeat
                              : (ref
                                          .read(musicProvider.notifier)
                                          .audioPlayer
                                          .loopMode ==
                                      LoopMode.all
                                  ? Icons.repeat
                                  : Icons.repeat_one),
                        ),
                        onPressed: () {
                          ref.read(musicProvider.notifier).toggleRepeatMode();
                        },
                        iconSize: 20,
                        color: ref
                                    .read(musicProvider.notifier)
                                    .audioPlayer
                                    .loopMode !=
                                LoopMode.off
                            ? Colors.orange
                            : Colors.grey,
                      ),
                      IconButton(
                        icon: const Icon(Icons.shuffle),
                        onPressed: () {
                          ref.read(musicProvider.notifier).toggleShuffle();
                        },
                        iconSize: 20,
                        color: musicPv.isShuffle ? Colors.orange : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
