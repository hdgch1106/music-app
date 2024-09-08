import 'package:flutter/material.dart';

class SlidingListVertical extends StatefulWidget {
  final List<Widget> children;
  final Duration slideDuration;
  const SlidingListVertical({
    super.key,
    required this.children,
    this.slideDuration = const Duration(seconds: 1),
  });

  @override
  State<SlidingListVertical> createState() => _SlidingListVerticalState();
}

class _SlidingListVerticalState extends State<SlidingListVertical>
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
      begin: const Offset(0.0, 1.0),
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
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return widget.children[index];
        },
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }
}
