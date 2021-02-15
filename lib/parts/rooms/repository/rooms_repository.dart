import 'package:meta/meta.dart';
import 'package:tada_team_chat/parts/rooms/data_provider/rooms_data_provider.dart';
import 'package:tada_team_chat/parts/rooms/models/room.dart';

class RoomsRepository {
  final RoomsDataProvider roomsDataProvider;
  RoomsRepository({@required this.roomsDataProvider})
      : assert(roomsDataProvider != null);

  Future<List<Room>> downloadRooms() async {
    Map<String, dynamic> json = await roomsDataProvider.downloadRooms();
    if (json['result'] != null) {
      return (json['result'] as List).map((e) => Room.fromJson(e)).toList();
    } else
      throw Exception('Empty response');
  }
}
