import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_cloud_api/presentation/Screens/home_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/login_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/player_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/player',
      name: 'player',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PlayerScreen(),
        transitionDuration: const Duration(milliseconds: 320),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final offsetAnimation =
              Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    ),
  ],
);
