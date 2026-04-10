import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_cloud_api/core/router.dart';
import 'package:sound_cloud_api/cubit_controller/track_cubit/cubit/track_cubit.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => BlocProvider(
        create: (_) => TrackCubit()..getTracks('Harry Styles'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
