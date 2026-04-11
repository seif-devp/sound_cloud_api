import 'package:flutter/material.dart';
import 'package:sound_cloud_api/core/app_colors.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? accentCyan : Colors.white38),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? accentCyan : Colors.white38,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
