import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart'; // مكتبة الصوت
import 'package:sound_cloud_api/data/models/track_model.dart';
import 'package:sound_cloud_api/data/services/deezer_services.dart';

part 'track_state.dart';

class TrackCubit extends Cubit<TrackState> {
  final deezerServices = DeezerServices();
  bool isPlaying = false; 

  final List<Track> recentTracks = [];

  final AudioPlayer audioPlayer = AudioPlayer();

  final List<Track> tracks = []; // القائمة الرئيسية للأغاني
  int currentTrackIndex = -1;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _completionSubscription;

  TrackCubit() : super(TrackInitial()) {
    _positionSubscription = audioPlayer.onPositionChanged.listen(
      _onPositionChanged,
    );
    _completionSubscription = audioPlayer.onPlayerComplete.listen(
      (_) => _onPlaybackComplete(),
    );
  }

  Future<void> getTracks(String name) async {
    emit(TrackLoading());
    try {
      final fetchedTracks = await deezerServices.searchTracks(name: name);
      tracks.clear();
      tracks.addAll(fetchedTracks);
      // بنبعت الداتا لأول مرة ومفيش حاجة شغالة
      emit(TrackLoaded(tracks: tracks, currentTrackIndex: -1));
    } catch (e) {
      emit(TrackError(e.toString()));
    }
  }

  Future<void> playTrack(Track track) async {
    // لازم نتأكد إن الداتا متحملة أصلاً عشان منضيعهاش
    if (state is TrackLoaded) {
      final currentState = state as TrackLoaded;

      if (currentState.currentTrack?.id == track.id) {
        if (currentState.isPlaying) {
          await audioPlayer.pause();
          emit(
            TrackLoaded(
              tracks: currentState.tracks,
              currentTrack: track,
              isPlaying: false,
              position: currentState.position,
              duration: currentState.duration,
              currentTrackIndex: currentTrackIndex,
            ),
          );
        } else {
          await audioPlayer.resume();
          emit(
            TrackLoaded(
              tracks: currentState.tracks,
              currentTrack: track,
              isPlaying: true,
              position: currentState.position,
              duration: currentState.duration,
              currentTrackIndex: currentTrackIndex,
            ),
          );
        }
      } else {
        await audioPlayer.stop();

        // إضافة الأغنية للقائمة إذا مش موجودة
        if (!tracks.any((t) => t.id == track.id)) {
          tracks.add(track);
          currentTrackIndex = tracks.length - 1;
        } else {
          currentTrackIndex = tracks.indexOf(track);
        }

        if (track.preview != null) {
          await audioPlayer.play(UrlSource(track.preview!));
        }

        // نضيفها في الـ Recent لو مش موجودة (بنقارن بالـ id)
        // استخدمنا insert(0) عشان الأغنية تنزل أول واحدة في اللستة
        if (!recentTracks.any((t) => t.id == track.id)) {
          recentTracks.insert(0, track);
        }

        emit(
          TrackLoaded(
            tracks: tracks,
            currentTrack: track,
            isPlaying: true,
            position: Duration.zero,
            duration: const Duration(seconds: 30),
            currentTrackIndex: currentTrackIndex,
          ),
        );
      }
    }
  }

  void _onPositionChanged(Duration position) {
    if (state is TrackLoaded) {
      final currentState = state as TrackLoaded;
      if (currentState.currentTrack != null) {
        final duration = currentState.duration;
        final adjustedPosition = position > duration ? duration : position;
        emit(
          TrackLoaded(
            tracks: currentState.tracks,
            currentTrack: currentState.currentTrack,
            isPlaying: currentState.isPlaying,
            position: adjustedPosition,
            duration: duration,
            currentTrackIndex: currentTrackIndex,
          ),
        );
      }
    }
  }

  void _onPlaybackComplete() {
    if (state is TrackLoaded) {
      final currentState = state as TrackLoaded;
      if (currentState.currentTrack != null) {
        emit(
          TrackLoaded(
            tracks: currentState.tracks,
            currentTrack: currentState.currentTrack,
            isPlaying: false,
            position: currentState.duration,
            duration: currentState.duration,
            currentTrackIndex: currentTrackIndex,
          ),
        );
      }
    }
  }

  void addToTracks(Track track) {
    if (!tracks.any((t) => t.id == track.id)) {
      tracks.add(track);
      if (state is TrackLoaded) {
        final currentState = state as TrackLoaded;
        emit(TrackLoaded(
          tracks: tracks,
          currentTrack: currentState.currentTrack,
          isPlaying: currentState.isPlaying,
          position: currentState.position,
          duration: currentState.duration,
          currentTrackIndex: currentTrackIndex,
        ));
      }
    }
  }

  void playNext() {
    if (currentTrackIndex < tracks.length - 1) {
      currentTrackIndex++;
      playTrack(tracks[currentTrackIndex]);
    }
  }

  void playPrevious() {
    if (currentTrackIndex > 0) {
      currentTrackIndex--;
      playTrack(tracks[currentTrackIndex]);
    }
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _completionSubscription?.cancel();
    audioPlayer.dispose();
    return super.close();
  }
}
