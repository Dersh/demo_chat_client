import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/parts/login/bloc/login_bloc.dart';
import 'package:tada_team_chat/parts/login/screens/error_screen.dart';
import 'package:tada_team_chat/parts/login/screens/splash_screen.dart';
import 'package:tada_team_chat/parts/rooms/bloc/rooms_bloc.dart';
import 'package:tada_team_chat/parts/rooms/screens/rooms_display.dart';
import 'package:tada_team_chat/sevices/connectivity_check.dart';

class Rooms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => context.read<LoginBloc>().add(LoginExited()),
          ),
          title: Text("Комнаты"),
        ),
        body: BlocConsumer<RoomsBloc, RoomsState>(
            listener: (context, state) {
              RoomsLoadSuccess _state = state;
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                      content: Text(
                          _state.connectionStatus == ConnectionStatus.connecting
                              ? 'соединение потеряно, переподключение...'
                              : 'соединение восстановлено')),
                );
            },
            listenWhen: (previous, current) =>
                (previous is RoomsLoadSuccess && current is RoomsLoadSuccess) &&
                current.connectionStatus != previous.connectionStatus,
            builder: (context, state) {
              if (state is RoomsLoadFailed)
                return ErrorScreen(
                    onRetryTapped: () => context
                        .read<RoomsBloc>()
                        .add(RoomsFetched(user: state.user)));
              else if (state is RoomsLoadSuccess)
                return RoomsDisplay(state: state);
              else
                return SplashScreen();
            }));
  }
}
