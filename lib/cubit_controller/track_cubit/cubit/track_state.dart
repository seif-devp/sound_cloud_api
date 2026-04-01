part of 'track_cubit.dart';

sealed class TrackState {}

final class TrackInitial extends TrackState {}

class TrackLoading extends TrackState {}

class TrackError extends TrackState {
  final String message;
  TrackError(this.message);
}

// 👇 كبرنا الـ State دي عشان تشيل الشاشة كلها (لستة الأغاني + الأغنية الشغالة)
final class TrackLoaded extends TrackState {
  final List<Track> tracks;
  final Track? currentTrack; // الأغنية اللي شغالة دلوقتي
  final bool isPlaying; // شغالة ولا متوقفة؟
  final Duration position; // موقع التشغيل الحالي
  final Duration duration; // مدة التشغيل (ثابتة 30 ثانية)

  TrackLoaded({
    required this.tracks,
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = const Duration(seconds: 30),
  });
}
