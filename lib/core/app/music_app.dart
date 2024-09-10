import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/core/core.dart';

class MusicApp extends ConsumerWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final appRouter = ref.watch(goRouterProvider);
    //final themePv = ref.watch(themeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Music App",
      theme: AppTheme().getDarkTheme(),
      //theme: themePv ? AppTheme().getDarkTheme() : AppTheme().getLightTheme(),
      routerConfig: appRouter,
      // routeInformationParser: appRouter.routeInformationParser,
      // routeInformationProvider: appRouter.routeInformationProvider,
      // routerDelegate: appRouter.routerDelegate,
    );
  }
}
