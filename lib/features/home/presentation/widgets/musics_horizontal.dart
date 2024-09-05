import 'package:flutter/material.dart';
import 'package:music_app/core/core.dart';

class MusicsHorizontal extends StatelessWidget {
  const MusicsHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Especial para ti",
          style: getSubtitleStyle().copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: size.height * 0.02),
        SizedBox(
          height: size.height * 0.26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: musics.length,
            itemBuilder: (context, index) {
              return _CustomMusicCard(
                size: size,
                musicUtil: musics[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CustomMusicCard extends StatelessWidget {
  const _CustomMusicCard({
    required this.size,
    required this.musicUtil,
  });

  final MusicUtil musicUtil;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: size.width * 0.03),
      child: SizedBox(
        width: size.width * 0.5,
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
                Stack(
                  children: [
                    Container(
                      height: size.height * 0.15,
                      width: size.width * 0.5,
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
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
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
