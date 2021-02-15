import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Блок логина

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  String user;

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SubmitLogin) {
      yield LoginLoading();
      try {
        user = event.user;
        yield LoginLoaded(event.user);
      } catch (e) {
        yield LoginError();
        throw ('Error SubmitLogin \n $e');
      }
    }
  }
}
