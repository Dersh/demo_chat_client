import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tada_team_chat/sevices/connectivity_check.dart';
import 'package:uuid/uuid.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tada_team_chat/parts/login/models/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends HydratedBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInput());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginSubmitted) {
      final status =
          await ConnectivityCheckService.connectivityCheck(['nane.tada.team']);
      if (status == ConnectionStatus.active)
        yield LoginSuccess(
            user: User(username: event.username, uid: Uuid().v1()));
      else
        yield LoginFailed();
    } else if (event is LoginRetried)
      yield LoginInput();
    else if (event is LoginExited) {
      await HydratedBloc.storage.clear();
      yield LoginInput();
    }
  }

  @override
  LoginState fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'LoginSuccess')
      return LoginSuccess(user: User.fromJson(json['user']));
    else
      return LoginInput();
  }

  @override
  Map<String, dynamic> toJson(LoginState state) {
    if (state is LoginSuccess)
      return {'type': 'LoginSuccess', 'user': state.user.toJson()};
    else if (state is LoginInput)
      return {'type': 'LoginInput'};
    else
      return null;
  }
}
