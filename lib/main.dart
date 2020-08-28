import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc/bloc_observer.dart';
import 'bloc/chat/chat_bloc.dart';
import 'pages/login.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<ChatBloc>(
            create: (context) =>
                ChatBloc(user: BlocProvider.of<LoginBloc>(context).user)
                  ..add(TryConnect())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Chat Demo';
    return MaterialApp(
      title: title,
      home: LoginForm(),
    );
  }
}
