part of 'chat_bloc.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}

class Loading extends ChatState {}

class Loaded extends ChatState {}

class UpdateDataState extends ChatState {
  final dynamic chatData;

  UpdateDataState(this.chatData);
}

class ConnectedOnDoneState extends ChatState {}
