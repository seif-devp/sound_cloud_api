import 'package:flutter/material.dart';
import 'package:sound_cloud_api/core/app_colors.dart';
import 'package:sound_cloud_api/presentation/widgets/mini_player_widget.dart';
import 'package:sound_cloud_api/presentation/widgets/nav_item.dart';

class BottomArea extends StatefulWidget {
  const BottomArea({Key? key}) : super(key: key);

  @override
  State<BottomArea> createState() => _BottomAreaState();
}

class _BottomAreaState extends State<BottomArea>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayerWidget(),
          Container(
            height: 70,
            color: bgColor,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(
                  icon: Icons.home_filled,
                  label: 'HOME',
                  routePath: '/home',
                ),
                NavItem(
                  icon: Icons.search,
                  label: 'SEARCH',
                  routePath: '/search',
                ),
                NavItem(
                  icon: Icons.library_music,
                  label: 'LIBRARY',
                  routePath: '/library',
                ),
                NavItem(
                  icon: Icons.person,
                  label: 'PROFILE',
                  routePath: '/profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
