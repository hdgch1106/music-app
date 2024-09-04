import 'package:flutter/material.dart';
import 'package:music_app/features/main_layout/presentation/presentation.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  const MainLayoutScreen({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: body,
          bottomNavigationBar: CustomBottomNavigationbar(
            currentIndex: selectedIndex,
            items: items,
            onDestinationSelected: onDestinationSelected,
          ),
        ),
      ],
    );
  }
}

class LayoutItem {
  final String name;
  final String iconPath;

  LayoutItem({
    required this.name,
    required this.iconPath,
  });
}

final items = [
  LayoutItem(
    name: "Inicio",
    iconPath: "assets/icons/home-2.png",
  ),
  LayoutItem(
    name: "Favoritos",
    iconPath: "assets/icons/lovely.png",
  ),
  LayoutItem(
    name: "Descargas",
    iconPath: "assets/icons/frame.png",
  ),
  LayoutItem(
    name: "Mi cuenta",
    iconPath: "assets/icons/profile.png",
  ),
];
