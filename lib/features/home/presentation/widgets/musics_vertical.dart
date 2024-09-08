import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/music/presentation/presentation.dart';

class MusicsVertical extends StatelessWidget {
  const MusicsVertical({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Musica Lo-fi",
            style: getSubtitleStyle().copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.02),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: musicLofi.length,
              itemBuilder: (context, index) {
                return _CustomMusicCard(
                  size: size,
                  musicUtil: musicLofi[index],
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(musicProvider.notifier)
                        .setPlaylist(musicLofi, index);
                    context.push("/music", extra: musicUtil);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: size.height * 0.1,
                        width: size.width * 0.18,
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
                SizedBox(width: size.width * 0.03),
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
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}