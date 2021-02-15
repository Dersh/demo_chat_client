import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/parts/login/bloc/login_bloc.dart';

class LoginFormInput extends StatefulWidget {
  @override
  _LoginFormInputState createState() => _LoginFormInputState();
}

class _LoginFormInputState extends State<LoginFormInput> {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';

  void _trySubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
      BlocProvider.of<LoginBloc>(context)
          .add(LoginSubmitted(username: _userName));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const InputDecoration(labelText: 'Имя пользователя'),
                  onSaved: (value) {
                    _userName = value;
                  },
                ),
                SizedBox(height: 12),
                RaisedButton(
                  child: const Text('Вход'),
                  onPressed: _trySubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
