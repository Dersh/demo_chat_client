import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/bloc/chat/chat_bloc.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    if (_controller.text.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(SendMessage(_controller.text));
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              autofocus: true,
              enableSuggestions: true,
              decoration: InputDecoration(hintText: 'Отправить сообщение...'),
              // Здесь можно кидать эвент в блок и стрим что пользователь печатает, не поддерживается бекендом
              onChanged: (value) {},
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.send,
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _sendMessage();
                }
              })
        ],
      ),
    );
  }
}
