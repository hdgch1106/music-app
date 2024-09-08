import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/music/presentation/presentation.dart';

class MusicsHorizontal extends StatelessWidget {
  const MusicsHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideInText(
          text: "Especial para ti",
          style: getSubtitleStyle().copyWith(fontWeight: FontWeight.bold),
          duration: const Duration(milliseconds: 2000),
        ),
        SizedBox(height: size.height * 0.02),
        /* SizedBox(
          height: size.height * 0.26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: musicSpecial.length,
            itemBuilder: (context, index) {
              return _CustomMusicCard(
                size: size,
                musicUtil: musicSpecial[index],
                index: index,
              );
            },
          ),
        ), */
        SlidingListHorizontal(
          children: musicSpecial.map((musicUtil) {
            return _CustomMusicCard(
              size: size,
              musicUtil: musicUtil,
              index: musicSpecial.indexOf(musicUtil),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CustomMusicCard extends ConsumerWidget {
  const _CustomMusicCard({
    required this.size,
    required this.musicUtil,
    required this.index,
  });

  final MusicUtil musicUtil;
  final Size size;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref
        .watch(favoriteProvider)
        .savedMusic
        .containsKey(musicUtil.id.toString());
    return Padding(
      padding: EdgeInsets.only(right: size.width * 0.03),
      child: SizedBox(
        width: size.width * 0.8,
        child: Card(
          color: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(musicProvider.notifier)
                        .setPlaylist(musicSpecial, index);
                    context.push("/music", extra: musicUtil);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: size.height * 0.15,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage(musicUtil.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.play_circle_outline_sharp,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          musicUtil.name,
                          style: getSubtitleStyle(),
                        ),
                        Text(
                          musicUtil.description,
                          style: getSmallSubtitleStyle().copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(favoriteProvider.notifier)
                            .saveMusic(musicUtil);
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
