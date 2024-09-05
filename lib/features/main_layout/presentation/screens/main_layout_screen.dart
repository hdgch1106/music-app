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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.1),
            child: Center(
              child: Image.asset(
                'assets/imgs/background.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
                height: size.height * 0.5,
              ),
            ),
          ),
          body,
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationbar(
        currentIndex: selectedIndex,
        items: items,
        onDestinationSelected: onDestinationSelected,
      ),
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
