import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/account/presentation/presentation.dart';
import 'package:music_app/features/music/presentation/presentation.dart';

class AccountView extends ConsumerWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final userPv = ref.watch(userProvider);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.05),
            Row(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/imgs/music_3.jpg'),
                ),
                SizedBox(width: size.width * 0.05),
                //Nombre
                //Seguidores . Siguiendo
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userPv.fullName,
                      style: getTitleStyle(),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${userPv.followers}',
                                style: getSubtitleStyle().copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' seguidores',
                                style: getSubtitleStyle().copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${userPv.following}',
                                style: getSubtitleStyle().copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' siguiendo',
                                style: getSubtitleStyle().copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            //Boton editar y 3 puntos
            SizedBox(height: size.height * 0.025),
            Row(
              children: [
                TextButton(
                  onPressed: () => context.push("/edit-profile"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.01,
                    ),
                  ),
                  child: Text(
                    'Editar',
                    style: getSubtitleStyle().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.02),
                TextButton(
                  onPressed: () =>
                      ref.read(musicFolderProvider.notifier).setMusicFolder(),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.01,
                    ),
                  ),
                  child: Text(
                    'Seleccionar carpeta',
                    style: getSubtitleStyle().copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
