import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tada_team_chat/parts/chat/bloc/chat_bloc.dart';
import 'package:tada_team_chat/parts/chat/data_provider/chat_data_provider.dart';
import 'package:tada_team_chat/parts/chat/repository/chat_repository.dart';
import 'package:tada_team_chat/parts/chat/screens/chat.dart';
import 'package:tada_team_chat/parts/rooms/bloc/rooms_bloc.dart';
import 'package:tada_team_chat/parts/rooms/repository/message_repository.dart';
import 'package:tada_team_chat/parts/rooms/screens/create_room.dart';

class RoomsDisplay extends StatefulWidget {
  final RoomsLoadSuccess state;
  RoomsDisplay({@required this.state}) : assert(state != null);
  @override
  _RoomsDisplayState createState() => _RoomsDisplayState();
}

class _RoomsDisplayState extends State<RoomsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => RepositoryProvider.value(
                value: context.read<MessageRepository>(),
                child: CreateRoom(user: widget.state.user)))),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<RoomsBloc>().add(RoomsFetched(user: widget.state.user));
          await context.read<RoomsBloc>().first;
        },
        child: ListView(
          physics:
              ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.symmetric(vertical: 15),
          children: ListTile.divideTiles(
            context: context,
            tiles: widget.state.rooms.map((e) => ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RepositoryProvider.value(
                            value: context.read<MessageRepository>(),
                            child: BlocProvider(
                              create: (context) => ChatBloc(
                                  messageRepository:
                                      context.read<MessageRepository>(),
                                  room: e.name,
                                  user: widget.state.user,
                                  chatRepository: ChatRepository(
                                      chatDataProvider: ChatDataProvider()))
                                ..add(ChatFetched()),
                              child: Chat(),
                            ),
                          ))),
                  title: Text(e.name),
                  subtitle: e.message != null
                      ? Text('${e.message.sender.username} : ${e.message.text}')
                      : Container(),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 20,
                  ),
                )),
          ).toList(),
        ),
      ),
    );
  }
}
