import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_cloud_api/presentation/Screens/home_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/library_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/login_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/player_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/profile_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/search_screen.dart';

// Helper function to create slide transition from right
CustomTransitionPage<dynamic> _buildPageWithTransition({
  required Widget child,
  required LocalKey pageKey,
  Offset beginOffset = const Offset(1.0, 0.0),
  Duration duration = const Duration(milliseconds: 400),
}) {
  return CustomTransitionPage(
    key: pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _buildPageWithTransition(
        child: const LoginScreen(),
        pageKey: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) => _buildPageWithTransition(
        child: const HomeScreen(),
        pageKey: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/player',
      name: 'player',
      pageBuilder: (context, state) => _buildPageWithTransition(
        child: const PlayerScreen(),
        pageKey: state.pageKey,
        beginOffset: const Offset(0, 1),
        duration: const Duration(milliseconds: 320),
      ),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder: (context, state) => _buildPageWithTransition(
        child: const ProfileScreen(),
        pageKey: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      pageBuilder: (context, state) => _buildPageWithTransition(
        child: const SearchScreen(),
        pageKey: state.pageKey,
      ),
    ),
    GoRoute(
      path: '/library',
      name: 'library',
      pageBuilder: (context, state) => _buildPageWithTransition(
        child: const LibraryScreen(),
        pageKey: state.pageKey,
      ),
    ),
  ],
);
