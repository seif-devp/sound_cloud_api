import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sound_cloud_api/cubit_controller/track_cubit/cubit/track_cubit.dart';
import 'package:sound_cloud_api/presentation/widgets/app_colors.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackCubit, TrackState>(
      builder: (context, state) {
        if (state is! TrackLoaded || state.currentTrack == null) {
          return const SizedBox();
        }

        final track = state.currentTrack!;
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1D1233),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      track.album.coverSmall,
                      width: 45,
                      height: 45,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          track.artist.name,
                          style: const TextStyle(
                            color: accentCyan,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.cast, color: Colors.white54, size: 20),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => context.read<TrackCubit>().playTrack(track),
                    child: CircleAvatar(
                      backgroundColor: accentCyan,
                      radius: 18,
                      child: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: BlocBuilder<TrackCubit, TrackState>(
                  builder: (context, state) {
                    return LinearProgressIndicator(
                      value: state is TrackLoaded && state.currentTrack != null
                          ? state.position.inMilliseconds /
                                state.duration.inMilliseconds
                          : 0.0,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        accentCyan,
                      ),
                      minHeight: 2,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
