part of 'login_screen_cubit.dart';


sealed class LoginScreenState {}

final class LoginScreenInitial extends LoginScreenState {}

final class LoginScreenLoading extends LoginScreenState {}
final class GoogleLoginLoading extends LoginScreenState {}

final class LoginScreenSuccess extends LoginScreenState {}

final class LoginScreenFailure extends LoginScreenState {
  final String errorMessage = 'error in login';
}
