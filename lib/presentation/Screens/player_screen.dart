import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_cloud_api/cubit_controller/music_player_cubit/player_ui_cubit.dart';
import 'package:sound_cloud_api/cubit_controller/track_cubit/cubit/track_cubit.dart';
import 'package:sound_cloud_api/core/app_colors.dart';
import 'package:sound_cloud_api/presentation/widgets/track_theme.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlayerUiCubit>(
      create: (_) => PlayerUiCubit(),
      child: BlocBuilder<TrackCubit, TrackState>(
        builder: (context, trackState) {
          return BlocBuilder<PlayerUiCubit, PlayerUiState>(
            builder: (context, uiState) {
              if (trackState is! TrackLoaded || trackState.currentTrack == null) {
                return Scaffold(
                  backgroundColor: bgColor,
                  body: SafeArea(
                    child: Center(
                      child: Text(
                        'No track is playing right now.',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ),
                  ),
                );
              }

              final track = trackState.currentTrack!;
              final progress = trackState.duration.inMilliseconds > 0
                  ? trackState.position.inMilliseconds / trackState.duration.inMilliseconds
                  : 0.0;

              // Load theme from image
              final themeFuture = TrackTheme.fromImageUrl(track.album.coverBig);

              return FutureBuilder<TrackTheme>(
                future: themeFuture,
                builder: (context, snapshot) {
                  final themeColors = snapshot.data ?? TrackTheme.fallback;

                  return Scaffold(
                    backgroundColor: bgColor,
                    body: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.topCenter,
                                radius: 1.0,
                                colors: [
                                  themeColors.primary.withOpacity(0.45),
                                  themeColors.secondary.withOpacity(0.18),
                                  bgColor,
                                ],
                                stops: const [0.0, 0.45, 1.0],
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          transform: Matrix4.translationValues(0, uiState.dragDistance, 0),
                          child: Opacity(
                            opacity: (1.0 - (uiState.dragDistance / 320.0)).clamp(0.55, 1.0),
                            child: SafeArea(
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onVerticalDragUpdate: (details) {
                                  final scrollController = ScrollController();
                                  if (scrollController.hasClients &&
                                      (scrollController.position.pixels <=
                                              scrollController.position.minScrollExtent + 0.5 ||
                                          uiState.dragDistance > 0)) {
                                    if (details.delta.dy > 0 || uiState.dragDistance > 0) {
                                      context.read<PlayerUiCubit>().updateDragDistance(details.delta.dy);
                                    }
                                  }
                                },
                                onVerticalDragEnd: (_) {
                                  final cubit = context.read<PlayerUiCubit>();
                                  if (cubit.shouldPop()) {
                                    context.pop();
                                  } else {
                                    cubit.resetDragDistance();
                                  }
                                },
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    final scrollController = ScrollController();
                                    if (scrollController.hasClients &&
                                        scrollController.position.pixels <=
                                            scrollController.position.minScrollExtent + 0.5) {
                                      if (notification is ScrollUpdateNotification &&
                                          notification.dragDetails != null &&
                                          notification.dragDetails!.delta.dy > 0) {
                                        context.read<PlayerUiCubit>().updateDragDistance(notification.dragDetails!.delta.dy);
                                        return true;
                                      }

                                      if (notification is OverscrollNotification &&
                                          notification.dragDetails != null &&
                                          notification.dragDetails!.delta.dy > 0) {
                                        context.read<PlayerUiCubit>().updateDragDistance(notification.dragDetails!.delta.dy.abs() * 0.8);
                                        return true;
                                      }
                                    }

                                    if (notification is ScrollEndNotification && uiState.dragDistance > 0) {
                                      final cubit = context.read<PlayerUiCubit>();
                                      if (cubit.shouldPop()) {
                                        context.pop();
                                      } else {
                                        cubit.resetDragDistance();
                                      }
                                    }

                                    return false;
                                  },
                                  child: SingleChildScrollView(
                                    controller: ScrollController(),
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Container(
                                                  width: 60,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 18),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () => context.pop(),
                                                    child: const CircleAvatar(
                                                      radius: 18,
                                                      backgroundColor: Color(0xFF2C2547),
                                                      child: Icon(
                                                        Icons.keyboard_arrow_down,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  const Expanded(
                                                    child: Text(
                                                      'Now Playing',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white54,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Image.network(
                                              track.album.coverBig,
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              height: MediaQuery.of(context).size.width * 0.9,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                track.title,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                track.artist.name,
                                                style: const TextStyle(
                                                  color: Colors.white54,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 26),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: LinearProgressIndicator(
                                                  value: progress.clamp(0.0, 1.0),
                                                  minHeight: 6,
                                                  backgroundColor: Colors.white12,
                                                  valueColor: AlwaysStoppedAnimation<Color>(themeColors.accent),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    _formatDuration(trackState.position),
                                                    style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatDuration(trackState.duration),
                                                    style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 32),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  _IconButton(
                                                    icon: Icons.shuffle,
                                                    label: 'Shuffle',
                                                  ),
                                                  _IconButton(
                                                    icon: Icons.skip_previous,
                                                    label: 'Prev',
                                                    onPressed: () => context.read<TrackCubit>().playPrevious(),
                                                  ),
                                                  CircleAvatar(
                                                    radius: 32,
                                                    backgroundColor: themeColors.accent,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        trackState.isPlaying ? Icons.pause : Icons.play_arrow,
                                                        color: Colors.black,
                                                        size: 32,
                                                      ),
                                                      onPressed: () => context.read<TrackCubit>().playTrack(track),
                                                    ),
                                                  ),
                                                  _IconButton(
                                                    icon: Icons.skip_next,
                                                    label: 'Next',
                                                    onPressed: () => context.read<TrackCubit>().playNext(),
                                                  ),
                                                  _IconButton(
                                                    icon: Icons.repeat,
                                                    label: 'Repeat',
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 38),
                                              const Text(
                                                'Up Next',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: themeColors.secondary.withOpacity(0.18),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                padding: const EdgeInsets.all(18),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(
                                                        track.album.coverSmall,
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 14),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            track.title,
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          const SizedBox(height: 6),
                                                          Text(
                                                            track.artist.name,
                                                            style: const TextStyle(
                                                              color: Colors.white54,
                                                              fontSize: 12,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.white54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.label, this.onPressed});

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed ?? () {},
          icon: Icon(icon, color: Colors.white54, size: 24),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
