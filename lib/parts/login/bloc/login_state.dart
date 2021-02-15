part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class LoginInput extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess({@required this.user}) : assert(user != null);
  @override
  List<Object> get props => [user];
}

class LoginFailed extends LoginState {}
