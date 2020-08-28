part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class SubmitLogin extends LoginEvent {
  final String user;

  SubmitLogin(this.user);

}
