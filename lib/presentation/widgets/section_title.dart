import 'package:flutter/material.dart';
import 'package:sound_cloud_api/core/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  const SectionTitle({Key? key, required this.title, required this.showSeeAll})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showSeeAll)
            const Text(
              'SEE ALL',
              style: TextStyle(
                color: accentCyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
