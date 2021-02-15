import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/parts/chat/bloc/chat_bloc.dart';
import 'package:tada_team_chat/parts/chat/screens/chat_main.dart';
import 'package:tada_team_chat/parts/login/screens/splash_screen.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      if (state is ChatLoadSuccess) {
        return ChatMain(state: state);
      } else
        return SplashScreen();
    });
  }
}
