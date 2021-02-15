import 'dart:async';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:tada_team_chat/sevices/connectivity_check.dart';
import 'package:tada_team_chat/parts/chat/models/message.dart';
import 'package:tada_team_chat/parts/chat/repository/chat_repository.dart';
import 'package:tada_team_chat/parts/login/models/user.dart';
import 'package:tada_team_chat/parts/rooms/repository/message_repository.dart';
import 'package:tada_team_chat/sevices/logger.dart';

part 'chat_event.dart';
part 'chat_state.dart';

const String greetingsText = 'Всем чмоки!';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(
      {@required this.room,
      @required this.user,
      @required this.chatRepository,
      @required this.messageRepository})
      : assert(chatRepository != null),
        assert(messageRepository != null),
        assert(room != null),
        assert(user != null),
        super(ChatInitial()) {
    messageSubscription = messageRepository.messageStream
        .where((message) => message.room == room)
        .listen(
          (event) => add(ChatMessageReceived(message: event)),
        );
    connectionStatusSubscription = messageRepository.connectionStatusStream
        .listen((event) => add(ChatConnectionStatusChanged(status: event)));
  }

  final String room;
  final User user;
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  StreamSubscription messageSubscription;
  StreamSubscription connectionStatusSubscription;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatFetched) {
      ChatLogger().memoryOutput.buffer.clear();
      ChatLogger().logger.i('чат $room открыт');
      var history =
          event.isRoomNew ? <Message>[] : await _downloadChatHistory();

      yield ChatLoadSuccess(
          connectionStatus: ConnectionStatus.active,
          room: room,
          messages: history,
          user: user);
      if (event.isRoomNew) add(ChatMessageSent(text: greetingsText));
    } else if (event is ChatMessageSent) {
      if (state is ChatLoadSuccess) {
        final userMessage = UserMessage(
            sender: Sender(username: user.username),
            text: event.text,
            id: Uuid().v1(),
            room: room);
        ChatLogger().logger.i('отправка сообщения ${userMessage.text}');
        messageRepository.sendMessage(userMessage);
        yield* _addMessages([userMessage]);
      }
    } else if (event is ChatMessageReceived) {
      if (state is ChatLoadSuccess) {
        ChatLogger().logger.i('получение сообщения  ${event.message.text}');
        if (event.message is UserMessage &&
            (state as ChatLoadSuccess)
                .messages
                .any((element) => element.id == event.message.id)) {
          var messages =
              List<Message>.from((state as ChatLoadSuccess).messages);
          messages.removeWhere((element) => element.id == event.message.id);
          yield (state as ChatLoadSuccess).copyWith(messages: messages);
        }
        yield* _addMessages([event.message]);
      }
    } else if (event is ChatConnectionStatusChanged) {
      if (state is ChatLoadSuccess) {
        if (event.status == ConnectionStatus.active) {
          if ((state as ChatLoadSuccess).connectionStatus ==
              ConnectionStatus.connecting) {
            var newMessages = [];
            final chatHistory = await _downloadChatHistory();
            if (chatHistory.isNotEmpty) {
              if ((state as ChatLoadSuccess)
                  .messages
                  .any((element) => element.created?.isNotEmpty ?? false))
                newMessages = chatHistory
                    .where((element) => DateTime.parse(element.created).isAfter(
                        DateTime.parse((state as ChatLoadSuccess)
                            .messages
                            .firstWhere((element) =>
                                element.created?.isNotEmpty ?? false)
                            .created)))
                    .toList();
              else
                newMessages = chatHistory;
            }
            if (newMessages.isNotEmpty) yield* _addMessages(newMessages);
          }
          var pendingUserMessages = (state as ChatLoadSuccess)
              .messages
              .where((element) => element is UserMessage && !element.isSent)
              .toList();
          while (pendingUserMessages.isNotEmpty) {
            messageRepository.sendMessage(pendingUserMessages.removeLast());
          }
        }
        yield (state as ChatLoadSuccess)
            .copyWith(connectionStatus: event.status);
      }
    }
  }

  Stream<ChatState> _addMessages(List<Message> messages) async* {
    yield (state as ChatLoadSuccess).copyWith(
        messages: [...messages, ...(state as ChatLoadSuccess).messages]);
  }

  Future<List<Message>> _downloadChatHistory() async {
    var history = <Message>[];
    try {
      history = await chatRepository.downloadChatHistory(user.username, room);
      history = history.reversed.toList();
    } catch (e) {
      ChatLogger().logger.i('ошибка при загрузке истории');
    }
    return history;
  }

  @override
  Future<void> close() {
    messageSubscription?.cancel();
    connectionStatusSubscription?.cancel();
    return super.close();
  }
}
