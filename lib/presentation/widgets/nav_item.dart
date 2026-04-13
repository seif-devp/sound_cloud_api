import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_cloud_api/core/app_colors.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String routePath;

  const NavItem({
    required this.icon,
    required this.label,
    required this.routePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current route location
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isSelected = currentLocation.contains(routePath);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          color: isSelected ? accentCyan : Colors.white38,
          onPressed: () {
            context.go(routePath);
          },
        ),
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
