import 'package:dio/dio.dart';

class ChatDataProvider {
  Future<Map<String, dynamic>> downloadChatHistory(String room) async {
    Response response = await Dio().get(
        'https://nane.tada.team/api/rooms/${Uri.encodeComponent(room)}/history');
    return response.data;
  }
}
