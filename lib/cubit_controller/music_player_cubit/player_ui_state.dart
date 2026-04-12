import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerUiState {
  final double dragDistance;

  PlayerUiState({this.dragDistance = 0.0});
}

class PlayerUiCubit extends Cubit<PlayerUiState> {
  static const double _popDistanceThreshold = 140.0;

  PlayerUiCubit() : super(PlayerUiState());

  void updateDragDistance(double delta) {
    emit(PlayerUiState(dragDistance: (state.dragDistance + delta).clamp(0.0, 280.0)));
  }

  void resetDragDistance() {
    emit(PlayerUiState(dragDistance: 0.0));
  }

  bool shouldPop() => state.dragDistance > _popDistanceThreshold;
}