import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(musicProvider.notifier).stopAndDispose();
        }
      },
      child: Scaffold(
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
              await ref.read(musicProvider.notifier).stopAndDispose();
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              musicUtil.name,
                              style: getTitleStyle(),
                            ),
                            Text(
                              musicUtil.description,
                              style: getSubtitleStyle().copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border),
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
                              .onSeek(Duration(seconds: value.toInt()));
                        },
                        onChangeEnd: (value) {
                          ref
                              .read(musicProvider.notifier)
                              .onSeek(Duration(seconds: value.toInt()));
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
                          onPressed: () {},
                          iconSize: 20,
                          color: Colors.grey,
                        ),
                        IconButton(
                          icon: const Icon(Icons.repeat),
                          onPressed: () {},
                          iconSize: 20,
                          color: Colors.grey,
                        ),
                        IconButton(
                          icon: const Icon(Icons.repeat_one),
                          onPressed: () {},
                          iconSize: 20,
                          color: Colors.grey,
                        ),
                        IconButton(
                          icon: const Icon(Icons.shuffle),
                          onPressed: () {},
                          iconSize: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
