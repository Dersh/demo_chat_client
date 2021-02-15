part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  LoginSubmitted({@required this.username}) : assert(username != null);
  @override
  List<Object> get props => [username];
}

class LoginRetried extends LoginEvent {}

class LoginExited extends LoginEvent {}
