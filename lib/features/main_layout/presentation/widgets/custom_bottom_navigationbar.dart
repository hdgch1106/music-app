import 'package:flutter/material.dart';
import 'package:music_app/core/core.dart';
import 'package:music_app/features/main_layout/presentation/presentation.dart';

class CustomBottomNavigationbar extends StatelessWidget {
  final List<LayoutItem> items;
  final int currentIndex;
  final Function(int) onDestinationSelected;
  const CustomBottomNavigationbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: kBottomNavigationBarHeight + 20,
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) {
              final item = items[index];
              return InkWell(
                onTap: () => onDestinationSelected(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   item.iconPath,
                      //   color: currentIndex == index
                      //       ? theme.navBarItemColor
                      //       : Colors.grey.shade500,
                      // ),
                      Image.asset(
                        item.iconPath,
                        color: currentIndex == index
                            ? theme.navBarItemColor
                            : Colors.grey.shade500,
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        item.name,
                        style: TextStyle(
                          color: currentIndex == index
                              ? theme.navBarItemColor
                              : Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
