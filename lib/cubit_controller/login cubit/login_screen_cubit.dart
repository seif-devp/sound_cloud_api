import 'package:flutter_bloc/flutter_bloc.dart';
part 'login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  LoginScreenCubit() : super(LoginScreenInitial());
  void login() {
    emit(LoginScreenLoading());
    Future.delayed(const Duration(seconds: 2), () {
      emit(LoginScreenSuccess());
    });
  }

  void loginfailure() {
    emit(GoogleLoginLoading());
    Future.delayed(const Duration(seconds: 2), () {
      emit(LoginScreenFailure());
      emit(LoginScreenInitial());
    });
  }
}
