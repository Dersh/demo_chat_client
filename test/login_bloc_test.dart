import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:tada_team_chat/bloc/login/login_bloc.dart';

class MockLoginBloc extends MockBloc implements LoginBloc {}

LoginBloc loginBloc;

void main() {
  test();
}

void test() {
  setUp(() {
    loginBloc = LoginBloc();
  });

  group('LoginBloc', () {
    final user = 'Andrey';
/*blocTest(
    'emits [] when nothing is added',
    build: () => loginBloc,
    expect: [LoginInitial()],
  );*/

    blocTest(
      'TestLogin',
      build: () => loginBloc,
      act: (bloc) => bloc.add(SubmitLogin('Andrey')),
      expect: [
        LoginLoading(),
        LoginLoaded(user),
      ],
    );
  });
}
