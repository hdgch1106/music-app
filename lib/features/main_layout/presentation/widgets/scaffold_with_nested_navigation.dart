import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/features/main_layout/presentation/presentation.dart';

class ScaffoldWithNestedNavigation extends ConsumerWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: true,
    );
    //ref.read(appBarProvider.notifier).update((state) => items[index].name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayoutScreen(
      body: navigationShell,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: _goBranch,
    );
  }
}
