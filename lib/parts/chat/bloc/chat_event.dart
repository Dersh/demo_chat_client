part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class ChatFetched extends ChatEvent {
  final bool isRoomNew;
  ChatFetched({this.isRoomNew = false}) : assert(isRoomNew != null);
  @override
  List<Object> get props => [isRoomNew];
}

class ChatMessageSent extends ChatEvent {
  final String text;
  ChatMessageSent({@required this.text}) : assert(text != null);
  @override
  List<Object> get props => [text];
}

class ChatMessageReceived extends ChatEvent {
  final Message message;
  ChatMessageReceived({@required this.message}) : assert(message != null);
  @override
  List<Object> get props => [message];
}

class ChatConnectionStatusChanged extends ChatEvent {
  final ConnectionStatus status;
  ChatConnectionStatusChanged({@required this.status}) : assert(status != null);
  @override
  List<Object> get props => [status];
}
