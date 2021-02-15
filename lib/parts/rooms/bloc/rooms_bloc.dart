import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tada_team_chat/parts/chat/models/message.dart';
import 'package:tada_team_chat/parts/login/models/user.dart';
import 'package:tada_team_chat/parts/rooms/models/room.dart';
import 'package:tada_team_chat/parts/rooms/repository/message_repository.dart';
import 'package:tada_team_chat/parts/rooms/repository/rooms_repository.dart';
import 'package:tada_team_chat/sevices/connectivity_check.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends HydratedBloc<RoomsEvent, RoomsState> {
  RoomsBloc({@required this.roomsRepository, @required this.messageRepository})
      : assert(roomsRepository != null),
        assert(messageRepository != null),
        super(RoomsInitial()) {
    messageSubscription = messageRepository.messageStream.listen(
      (event) => add(RoomsMessageReceived(message: event)),
    );
    connectionStatusSubscription = messageRepository.connectionStatusStream
        .distinct()
        .listen((event) =>
            add(RoomsConnectionStatusChanged(connectionStatus: event)));
  }

  final RoomsRepository roomsRepository;
  final MessageRepository messageRepository;
  StreamSubscription messageSubscription;
  StreamSubscription connectionStatusSubscription;

  @override
  Stream<RoomsState> mapEventToState(
    RoomsEvent event,
  ) async* {
    if (event is RoomsOpened && state is! RoomsLoadSuccess)
      add(RoomsFetched(user: event.user));
    else if (event is RoomsFetched) {
      try {
        List<Room> rooms = await roomsRepository.downloadRooms();
        rooms
            .sort((a, b) => -a.message?.created?.compareTo(b.message?.created));
        yield RoomsLoadSuccess(
            user: event.user,
            rooms: rooms,
            connectionStatus: ConnectionStatus.active);
      } catch (e) {
        print(e);
        yield RoomsLoadFailed(user: event.user);
      }
    } else if (event is RoomsConnectionStatusChanged) {
      if (state is RoomsLoadSuccess) {
        yield (state as RoomsLoadSuccess)
            .copyWith(connectionStatus: event.connectionStatus);
        if (event.connectionStatus == ConnectionStatus.active)
          add(RoomsFetched(user: (state as RoomsLoadSuccess).user));
      } else if (state is RoomsLoadFailed) {
        if (event.connectionStatus == ConnectionStatus.active)
          add(RoomsFetched(user: (state as RoomsLoadFailed).user));
      }
    } else if (event is RoomsMessageReceived) {
      if (state is RoomsLoadSuccess) {
        List<Room> rooms = List.from((state as RoomsLoadSuccess).rooms);
        Room room = rooms.firstWhere(
            (element) => element.name == event.message.room,
            orElse: () => null);
        if (room != null)
          rooms[rooms.indexOf(room)] = room.copyWith(message: event.message);
        else
          rooms.add(Room(name: event.message.room, message: event.message));
        rooms
            .sort((a, b) => -a.message?.created?.compareTo(b.message?.created));
        yield (state as RoomsLoadSuccess).copyWith(rooms: rooms);
      }
    }
  }

  @override
  RoomsState fromJson(Map<String, dynamic> json) {
    return RoomsLoadSuccess(
        user: User.fromJson(json['user']),
        rooms: (json['rooms'] as List).map((e) => Room.fromJson(e)).toList(),
        connectionStatus: ConnectionStatus.values
            .firstWhere((element) => element.toString() == json['connection']));
  }

  @override
  Map<String, dynamic> toJson(RoomsState state) {
    if (state is RoomsLoadSuccess)
      return {
        'user': state.user.toJson(),
        'rooms': state.rooms.map((e) => e.toJson()).toList(),
        'connection': state.connectionStatus.toString()
      };
    else
      return null;
  }

  @override
  Future<void> close() {
    messageRepository?.dispose();
    messageSubscription?.cancel();
    connectionStatusSubscription?.cancel();
    return super.close();
  }
}
