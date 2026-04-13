import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_cloud_api/core/app_colors.dart';
import 'package:sound_cloud_api/cubit_controller/track_cubit/cubit/track_cubit.dart';
import 'package:sound_cloud_api/presentation/widgets/bottom_area.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  Timer? _debounce;

  // Genre categories
  final List<GenreCategory> genres = [
    GenreCategory(title: 'Pop', color: const Color(0xFF006064), icon: '🎤'),
    GenreCategory(title: 'Rock', color: const Color(0xFFF44336), icon: '🎸'),
    GenreCategory(
      title: 'Hip-Hop',
      color: const Color(0xFF9C27B0),
      icon: '🎙️',
    ),
    GenreCategory(title: 'Jazz', color: const Color(0xFFA0522D), icon: '🎷'),
    GenreCategory(
      title: 'Classical',
      color: const Color(0xFF3F51B5),
      icon: '🎻',
    ),
    GenreCategory(
      title: 'Electronic',
      color: const Color(0xFF00BCD4),
      icon: '🎹',
    ),
    GenreCategory(title: 'R&B', color: const Color(0xFFE91E63), icon: '🎵'),
    GenreCategory(title: 'Country', color: const Color(0xFFADD846), icon: '🤠'),
    GenreCategory(title: 'Latin', color: const Color(0xFFC40E80), icon: '💃'),
    GenreCategory(title: 'Indie', color: const Color(0xFF7B2CBF), icon: '🎬'),
    GenreCategory(title: 'K-pop', color: const Color(0xFFC10F40), icon: '⭐'),
    GenreCategory(title: 'Arabic', color: const Color(0xFF009688), icon: '🌍'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<TrackCubit, TrackState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => context.go('/home'),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: cardBgColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: accentCyan.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.grey[500],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Search songs, artists...',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          if (_debounce?.isActive ?? false) {
                                            _debounce!.cancel();
                                          }
                                          _debounce = Timer(
                                            const Duration(milliseconds: 600),
                                            () {
                                              if (value.isNotEmpty) {
                                                context
                                                    .read<TrackCubit>()
                                                    .getTracks(value);
                                              }
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    if (_searchController.text.isNotEmpty)
                                      GestureDetector(
                                        onTap: () {
                                          _searchController.clear();
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.grey[500],
                                          size: 20,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Browse All Categories
                      if (_searchController.text.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Browse all',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 1.2,
                                    ),
                                itemCount: genres.length,
                                itemBuilder: (context, index) {
                                  return _GenreTile(genre: genres[index]);
                                },
                              ),
                            ],
                          ),
                        ),
                      // Search Results
                      if (_searchController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Results for "${_searchController.text}"',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (state is TrackLoading)
                                const Center(
                                  child: SpinKitCircle(
                                    color: accentCyan,
                                    size: 50,
                                  ),
                                )
                              else if (state is TrackLoaded)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.tracks.length,
                                  itemBuilder: (context, index) {
                                    final track = state.tracks[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: cardBgColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            child: Image.network(
                                              track.album.coverSmall,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  track.title,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  track.artist.name,
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => context
                                                .read<TrackCubit>()
                                                .playTrack(track),
                                            child: Icon(
                                              Icons.play_circle_outline,
                                              color: accentCyan,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              else if (state is TrackError)
                                Center(
                                  child: Text(
                                    'Error: ${state.message}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            // Bottom Navigation
            Positioned(bottom: 0, left: 0, right: 0, child: const BottomArea()),
          ],
        ),
      ),
    );
  }
}

class _GenreTile extends StatelessWidget {
  final GenreCategory genre;

  const _GenreTile({required this.genre});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Search for this genre
        context.read<TrackCubit>().getTracks(genre.title.toLowerCase());
      },
      child: Container(
        decoration: BoxDecoration(
          color: genre.color,
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [genre.color, genre.color.withOpacity(0.6)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                genre.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Transform.rotate(
                  angle: 0.3,
                  child: Text(genre.icon, style: const TextStyle(fontSize: 40)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenreCategory {
  final String title;
  final Color color;
  final String icon;

  GenreCategory({required this.title, required this.color, required this.icon});
}

// Keep CategoryCard for backward compatibility if needed
class CategoryCard {
  final String title;
  final Color color;
  final String icon;

  CategoryCard({required this.title, required this.color, required this.icon});
}
