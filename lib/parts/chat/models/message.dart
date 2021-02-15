import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

Message parseMessage(Map<String, dynamic> messageJson, String username) {
  if (messageJson['sender'] != null &&
      messageJson['sender']['username'] == username)
    return UserMessage.fromJson(messageJson);
  else
    return ReceivedMessage.fromJson(messageJson);
}

abstract class Message extends Equatable {
  final String room;
  final String created;
  final Sender sender;
  final String text;
  final String id;

  Message(
      {@required this.room,
      @required this.created,
      @required this.sender,
      @required this.text,
      @required this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['room'] = this.room;
    if (created != null) data['created'] = this.created;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    data['text'] = this.text;
    return data;
  }

  @override
  List<Object> get props => [room, created, sender, text, id];

  @override
  String toString() {
    return 'Message{room: $room, created: $created, text: $text, id: $id}';
  }
}

class ReceivedMessage extends Message {
  ReceivedMessage(
      {String room, String created, Sender sender, String text, String id})
      : super(room: room, created: created, sender: sender, text: text, id: id);
  factory ReceivedMessage.fromJson(Map<String, dynamic> json) {
    return ReceivedMessage(
      id: json['id'],
      room: json['room'],
      created: json['created'],
      sender:
          json['sender'] != null ? new Sender.fromJson(json['sender']) : null,
      text: json['text'],
    );
  }
}

class UserMessage extends Message {
  final bool isSent;
  UserMessage(
      {String room,
      String created,
      Sender sender,
      String text,
      String id,
      this.isSent = false})
      : super(room: room, created: created, sender: sender, text: text, id: id);

  factory UserMessage.fromJson(Map<String, dynamic> json) {
    return UserMessage(
      isSent: true,
      id: json['id'],
      room: json['room'],
      created: json['created'],
      sender:
          json['sender'] != null ? new Sender.fromJson(json['sender']) : null,
      text: json['text'],
    );
  }

  UserMessage copyWith({
    bool isSent,
  }) {
    return UserMessage(
      isSent: isSent ?? this.isSent,
      room: room,
      created: created,
      sender: sender,
      text: text,
      id: id,
    );
  }
}

class Sender extends Equatable {
  final String username;

  Sender({this.username});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['username'] = this.username;
    return data;
  }

  @override
  List<Object> get props => [username];
}
