import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/features/main_layout/presentation/presentation.dart';

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
                  child: Container(),
                );
              },
              // routes: [
              //   GoRoute(
              //     path: 'services',
              //     pageBuilder: (context, state) {
              //       final viewUtil = state.extra as ServicesViewUtil;
              //       return NoTransitionPage(
              //         key: state.pageKey,
              //         child: ServicesView(
              //           viewUtil: viewUtil,
              //         ),
              //       );
              //     },
              //   ),
              // ],
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
                  child: Container(),
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
                  child: Container(),
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
  ],
);
