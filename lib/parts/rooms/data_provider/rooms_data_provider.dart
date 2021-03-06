import 'package:dio/dio.dart';

class RoomsDataProvider {
  Future<Map<String, dynamic>> downloadRooms() async {
    Response response = await Dio().get('https://nane.tada.team/api/rooms');
    return response.data;
  }
}
