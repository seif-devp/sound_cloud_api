import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sound_cloud_api/cubit_controller/track_cubit/cubit/track_cubit.dart';
import 'package:sound_cloud_api/core/app_colors.dart';
import 'package:sound_cloud_api/presentation/widgets/bottom_area.dart';
import 'package:sound_cloud_api/presentation/widgets/categories_widget.dart';
import 'package:sound_cloud_api/presentation/widgets/header_widget.dart';
import 'package:sound_cloud_api/presentation/widgets/section_title.dart';
import 'package:sound_cloud_api/presentation/widgets/trending_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // تحميل الأغاني الافتراضية عند فتح الصفحة
    Future.delayed(Duration.zero, () {
      context.read<TrackCubit>().getTracks('harry styles');
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 150),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderWidget(),
                  CategoriesWidget(),
                  const SectionTitle(title: 'Mixes for You', showSeeAll: true),
                  MixesListWidget(), // مربوط بالكيوبت
                  const SectionTitle(
                    title: 'Recently Played',
                    showSeeAll: false,
                  ),
                  RecentlyPlayedWidget(), // مربوط بالكيوبت (بدون const)
                  const SectionTitle(
                    title: 'Trending Near You',
                    showSeeAll: false,
                  ),
                  const TrendingSectionWidget(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomArea(), // مربوط بالكيوبت (بدون const)
            ),
          ],
        ),
      ),
    );
  }
}

// --- Mixes List (الربط تم هنا) ---
class MixesListWidget extends StatelessWidget {
  const MixesListWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: BlocBuilder<TrackCubit, TrackState>(
        builder: (context, state) {
          if (state is TrackLoading) {
            return const Center(
              child: SpinKitCircle(color: accentCyan, size: 50),
            );
          } else if (state is TrackLoaded) {
            if (state.tracks.isEmpty) {
              return const Center(
                child: Text(
                  "No tracks available",
                  style: TextStyle(color: Colors.white54),
                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: state.tracks.length,
              itemBuilder: (context, i) {
                final track = state.tracks[i];
                return GestureDetector(
                  onTap: () => context.read<TrackCubit>().playTrack(track),
                  child: Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: NetworkImage(track.album.coverBig),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 15,
                                left: 15,
                                child: CircleAvatar(
                                  backgroundColor: accentCyan,
                                  radius: 18,
                                  child: BlocBuilder<TrackCubit, TrackState>(
                                    builder: (context, state) {
                                      return Icon(
                                        state is TrackLoaded &&
                                                state.currentTrack?.id ==
                                                    track.id
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.black,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          track.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          track.artist.name,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TrackError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          // TrackInitial state - show loading spinner
          return const Center(
            child: SpinKitCircle(color: accentCyan, size: 50),
          );
        },
      ),
    );
  }
}

// --- Recently Played (الربط تم هنا) ---
class RecentlyPlayedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // بيراقب لستة الـ recentTracks اللي في الكيوبت
    final tracks = context.watch<TrackCubit>().recentTracks.take(4).toList();

    if (tracks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No tracks played yet",
          style: TextStyle(color: Colors.white24),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: tracks.length,
      itemBuilder: (context, i) {
        final track = tracks[i];
        return GestureDetector(
          onTap: () => context.read<TrackCubit>().playTrack(track),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    track.album.coverSmall,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track.artist.name,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
