import 'package:flutter/material.dart';
import 'package:sound_cloud_api/core/app_colors.dart';
import 'package:sound_cloud_api/presentation/widgets/mini_player_widget.dart';
import 'package:sound_cloud_api/presentation/widgets/nav_item.dart';

class BottomArea extends StatelessWidget {
  const BottomArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MiniPlayerWidget(),
        Container(
          height: 70,
          color: bgColor,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(icon: Icons.home_filled, label: 'HOME', isSelected: true),
              NavItem(icon: Icons.search, label: 'SEARCH'),
              NavItem(icon: Icons.library_music, label: 'LIBRARY'),
              NavItem(icon: Icons.person, label: 'PROFILE'),
            ],
          ),
        ),
      ],
    );
  }
}
