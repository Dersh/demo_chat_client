import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tada_team_chat/parts/login/bloc/login_bloc.dart';
import 'package:tada_team_chat/parts/login/screens/error_screen.dart';
import 'package:tada_team_chat/parts/login/screens/login_form_input.dart';
import 'package:tada_team_chat/parts/login/screens/splash_screen.dart';
import 'package:tada_team_chat/parts/rooms/bloc/rooms_bloc.dart';
import 'package:tada_team_chat/parts/rooms/data_provider/rooms_data_provider.dart';
import 'package:tada_team_chat/parts/rooms/repository/message_repository.dart';
import 'package:tada_team_chat/parts/rooms/repository/rooms_repository.dart';
import 'package:tada_team_chat/parts/rooms/screens/rooms.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoginInput) {
        return LoginFormInput();
      } else if (state is LoginSuccess) {
        return RepositoryProvider(
          create: (context) => MessageRepository(user: state.user),
          child: BlocProvider(
              create: (context) => RoomsBloc(
                  messageRepository: context.read<MessageRepository>(),
                  roomsRepository:
                      RoomsRepository(roomsDataProvider: RoomsDataProvider()))
                ..add(RoomsOpened(user: state.user)),
              child: Rooms()),
        );
      } else if (state is LoginFailed) {
        return ErrorScreen(
            onRetryTapped: () => context.read<LoginBloc>().add(LoginRetried()));
      } else
        return SplashScreen();
    });
  }
}
