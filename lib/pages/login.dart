import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/bloc/login/login_bloc.dart';
import 'package:tada_team_chat/pages/chat.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';

  void _trySubmit() {
    // Валидация
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      // Отправляем эвент в блок
      BlocProvider.of<LoginBloc>(context).add(SubmitLogin(_userName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        if (state is LoginLoading) {
          return Center(
            child: Card(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is LoginLoaded) {
          return ChatPage(user: state.user);
        }
        if (state is LoginError) {
          return Center(
            child: Card(
              child: Column(
                children: [
                  Text(
                    'Ошибка',
                    style: TextStyle(color: Colors.red),
                  ),
                  RaisedButton(
                    child: const Text('Еще раз'),
                    onPressed: _trySubmit,
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
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
                      // Валидация
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Пожалуйста введите более 3-х символов';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Имя пользователя'),
                      onSaved: (value) {
                        _userName = value;
                      },
                      onChanged: (value) {
                        _userName = value;
                      },
                    ),
                    SizedBox(height: 12),
                    RaisedButton(
                      child: const Text('Логин'),
                      onPressed: _trySubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
