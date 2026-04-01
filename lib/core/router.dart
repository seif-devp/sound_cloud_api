import 'package:go_router/go_router.dart';
import 'package:sound_cloud_api/presentation/Screens/home_screen.dart';
import 'package:sound_cloud_api/presentation/Screens/login_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);
