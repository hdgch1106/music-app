import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/features/downloads/presentation/presentation.dart';
import 'package:music_app/features/favorites/presentation/views/favorites_view.dart';
import 'package:music_app/features/home/presentation/presentation.dart';
import 'package:music_app/features/main_layout/presentation/presentation.dart';
import 'package:music_app/features/music/presentation/presentation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shell1NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell1');
final _shell2NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell2');
final _shell3NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell3');
final _shell4NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell4');

final appRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    //Pantalla de home
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(
          key: state.pageKey,
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shell1NavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const HomeView(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shell2NavigatorKey,
          routes: [
            GoRoute(
              path: '/favourites',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const FavoritesView(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shell3NavigatorKey,
          routes: [
            GoRoute(
              path: '/downloads',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const DownloadsView(),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shell4NavigatorKey,
          routes: [
            GoRoute(
              path: '/account',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: Container(),
                );
              },
            ),
          ],
        )
      ],
    ),
    //Pantalla de música
    GoRoute(
      path: '/music',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: state.pageKey,
          child: const MusicScreen(),
        );
      },
    ),
  ],
);
