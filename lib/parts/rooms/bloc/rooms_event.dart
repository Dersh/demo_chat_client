part of 'rooms_bloc.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();
  @override
  List<Object> get props => [];
}

class RoomsOpened extends RoomsEvent {
  final User user;
  RoomsOpened({@required this.user}) : assert(user != null);
  @override
  List<Object> get props => [user];
}

class RoomsFetched extends RoomsEvent {
  final User user;
  RoomsFetched({@required this.user}) : assert(user != null);
  @override
  List<Object> get props => [user];
}

class RoomsConnectionStatusChanged extends RoomsEvent {
  final ConnectionStatus connectionStatus;
  RoomsConnectionStatusChanged({@required this.connectionStatus})
      : assert(connectionStatus != null);
  @override
  List<Object> get props => [connectionStatus];
}

class RoomsMessageReceived extends RoomsEvent {
  final Message message;
  RoomsMessageReceived({@required this.message}) : assert(message != null);
  @override
  List<Object> get props => [message];
}
