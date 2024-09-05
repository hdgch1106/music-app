import 'package:flutter/material.dart';
import 'package:music_app/features/home/presentation/presentation.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              const TopTitle(),
              SizedBox(height: size.height * 0.03),
              const MusicsHorizontal(),
            ],
          ),
        ),
      ),
    );
  }
}
