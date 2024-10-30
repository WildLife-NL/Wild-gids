import 'package:flutter/material.dart';

class BottomNavigationBarIndicator extends StatelessWidget {
  const BottomNavigationBarIndicator({
    super.key,
    this.selectedIndex = 0,
    required this.indicatorWidth,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  final Duration animationDuration;
  final int selectedIndex;
  final double indicatorWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: animationDuration,
      curve: Curves.easeInOut,
      top: 0,
      left: selectedIndex * MediaQuery.of(context).size.width / 3,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Container(
            color: Theme.of(context).primaryColor,
            width: 60,
            height: 3,
          ),
        ),
      ),
    );
  }
}
