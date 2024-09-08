import 'package:flutter/material.dart';

class SlidingListHorizontal extends StatefulWidget {
  final List<Widget> children;
  final Duration slideDuration;
  const SlidingListHorizontal({
    super.key,
    required this.children,
    this.slideDuration = const Duration(seconds: 1),
  });

  @override
  State<SlidingListHorizontal> createState() => _SlidingListHorizontalState();
}

class _SlidingListHorizontalState extends State<SlidingListHorizontal>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: widget.slideDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );

    _slideController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.26,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.children.length,
          itemBuilder: (context, index) {
            return widget.children[index];
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
}
