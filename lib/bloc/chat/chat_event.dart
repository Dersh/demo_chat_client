part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage(this.message);
}

class UpdateData extends ChatEvent {
  final dynamic chatData;

  UpdateData(this.chatData);
}

class TryConnect extends ChatEvent {}

class ConnectedOnDone extends ChatEvent {}

class ConnectedError extends ChatEvent {}
