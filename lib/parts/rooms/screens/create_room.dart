import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/parts/chat/bloc/chat_bloc.dart';
import 'package:tada_team_chat/parts/chat/data_provider/chat_data_provider.dart';
import 'package:tada_team_chat/parts/chat/repository/chat_repository.dart';
import 'package:tada_team_chat/parts/chat/screens/chat.dart';
import 'package:tada_team_chat/parts/login/models/user.dart';
import 'package:tada_team_chat/parts/rooms/repository/message_repository.dart';

class CreateRoom extends StatefulWidget {
  final User user;
  CreateRoom({@required this.user}) : assert(user != null);
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final _formKey = GlobalKey<FormState>();
  var _roomName = '';

  void _tryCreate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => RepositoryProvider.value(
                value: context.read<MessageRepository>(),
                child: BlocProvider(
                  create: (context) => ChatBloc(
                      messageRepository:
                          context.read<MessageRepository>(),
                      room: _roomName,
                      user: widget.user,
                      chatRepository:
                          ChatRepository(chatDataProvider: ChatDataProvider()))
                    ..add(ChatFetched(isRoomNew: true)),
                  child: Chat(),
                ),
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Создать комнату"),
        ),
        body: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      autocorrect: true,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Пожалуйста введите более 3-х символов';
                        } else if (value.length > 20)
                          return 'Имя не должно содержать больше 20 символов';
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Имя комнаты'),
                      onSaved: (value) {
                        _roomName = value;
                      },
                    ),
                    SizedBox(height: 12),
                    RaisedButton(
                      child: const Text('Создать комнату'),
                      onPressed: _tryCreate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
