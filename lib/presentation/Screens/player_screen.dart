import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_cloud_api/cubit_controller/track_cubit/cubit/track_cubit.dart';
import 'package:sound_cloud_api/presentation/widgets/app_colors.dart';
import 'package:sound_cloud_api/presentation/widgets/track_theme.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _dragResetController;
  late Animation<double> _dragResetAnimation;
  double _dragDistance = 0.0;
  static const double _popDistanceThreshold = 140.0;

  // Cache for theme colors from image
  String? _cachedImageUrl;
  late Future<TrackTheme> _themeFuture;

  @override
  void initState() {
    super.initState();
    _dragResetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _dragResetAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(_dragResetController);
    _dragResetController.addListener(() {
      setState(() {
        _dragDistance = _dragResetAnimation.value;
      });
    });
  }

  void _updateDragDistance(double delta) {
    setState(() {
      _dragDistance = (_dragDistance + delta).clamp(0.0, 280.0);
    });
  }

  void _resetDragDistance() {
    if (_dragDistance == 0) return;

    _dragResetAnimation = Tween<double>(begin: _dragDistance, end: 0.0).animate(
      CurvedAnimation(parent: _dragResetController, curve: Curves.easeOutCubic),
    );
    _dragResetController.forward(from: 0.0);
  }

  void _tryDismiss() {
    if (_dragDistance > _popDistanceThreshold) {
      context.pop();
    } else {
      _resetDragDistance();
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels <=
            _scrollController.position.minScrollExtent + 0.5) {
      if (notification is ScrollUpdateNotification &&
          notification.dragDetails != null &&
          notification.dragDetails!.delta.dy > 0) {
        _updateDragDistance(notification.dragDetails!.delta.dy);
        return true;
      }

      if (notification is OverscrollNotification &&
          notification.dragDetails != null &&
          notification.dragDetails!.delta.dy > 0) {
        _updateDragDistance(notification.dragDetails!.delta.dy.abs() * 0.8);
        return true;
      }
    }

    if (notification is ScrollEndNotification && _dragDistance > 0) {
      _tryDismiss();
    }

    return false;
  }

  @override
  void dispose() {
    _dragResetController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCubit, TrackState>(
      builder: (context, state) {
        if (state is! TrackLoaded || state.currentTrack == null) {
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

        final track = state.currentTrack!;
        final progress = state.duration.inMilliseconds > 0
            ? state.position.inMilliseconds / state.duration.inMilliseconds
            : 0.0;

        // Load theme from image only if the track changed
        if (_cachedImageUrl != track.album.coverBig) {
          _cachedImageUrl = track.album.coverBig;
          _themeFuture = TrackTheme.fromImageUrl(track.album.coverBig);
        }

        return FutureBuilder<TrackTheme>(
          future: _themeFuture,
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
                  Transform.translate(
                    offset: Offset(0, _dragDistance),
                    child: Opacity(
                      opacity: (1.0 - (_dragDistance / 320.0)).clamp(0.55, 1.0),
                      child: SafeArea(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragUpdate: (details) {
                            if (_scrollController.hasClients &&
                                (_scrollController.position.pixels <=
                                        _scrollController
                                                .position
                                                .minScrollExtent +
                                            0.5 ||
                                    _dragDistance > 0)) {
                              if (details.delta.dy > 0 || _dragDistance > 0) {
                                _updateDragDistance(details.delta.dy);
                              }
                            }
                          },
                          onVerticalDragEnd: (_) => _tryDismiss(),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: _handleScrollNotification,
                            child: SingleChildScrollView(
                              controller: _scrollController,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                                backgroundColor: Color(
                                                  0xFF2C2547,
                                                ),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.9,
                                        height:
                                            MediaQuery.of(context).size.width *
                                            0.9,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: progress.clamp(0.0, 1.0),
                                            minHeight: 6,
                                            backgroundColor: Colors.white12,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  themeColors.accent,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(state.position),
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              _formatDuration(state.duration),
                                              style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 32),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            _IconButton(
                                              icon: Icons.shuffle,
                                              label: 'Shuffle',
                                            ),
                                            _IconButton(
                                              icon: Icons.skip_previous,
                                              label: 'Prev',
                                              onPressed: () {
                                                // no-op for now, safe placeholder
                                              },
                                            ),
                                            CircleAvatar(
                                              radius: 32,
                                              backgroundColor:
                                                  themeColors.accent,
                                              child: IconButton(
                                                icon: Icon(
                                                  state.isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                  color: Colors.black,
                                                  size: 32,
                                                ),
                                                onPressed: () {
                                                  context
                                                      .read<TrackCubit>()
                                                      .playTrack(track);
                                                },
                                              ),
                                            ),
                                            _IconButton(
                                              icon: Icons.skip_next,
                                              label: 'Next',
                                              onPressed: () {
                                                // no-op for now, safe placeholder
                                              },
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
                                            color: themeColors.secondary
                                                .withOpacity(0.18),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(18),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
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
