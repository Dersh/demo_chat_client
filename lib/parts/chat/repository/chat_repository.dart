import 'package:meta/meta.dart';

import 'package:tada_team_chat/parts/chat/data_provider/chat_data_provider.dart';
import 'package:tada_team_chat/parts/chat/models/message.dart';

class ChatRepository {
  final ChatDataProvider chatDataProvider;
  ChatRepository({@required this.chatDataProvider})
      : assert(chatDataProvider != null);

  Future<List<Message>> downloadChatHistory(
      String username, String room) async {
    Map<String, dynamic> json =
        await chatDataProvider.downloadChatHistory(room);
    if (json['result'] != null)
      return (json['result'] as List)
          .map((e) => parseMessage(e, username))
          .toList();
    else
      return [];
  }
}
