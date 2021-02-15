import 'package:equatable/equatable.dart';
import 'package:tada_team_chat/parts/chat/models/message.dart';

class Room extends Equatable {
  final String name;
  final Message message;

  Room({this.name, this.message});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      name: json['name'],
      message: json['last_message'] != null
          ? new ReceivedMessage.fromJson(json['last_message'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    if (this.message != null) {
      data['last_message'] = this.message.toJson();
    }
    return data;
  }

  Room copyWith({
    String name,
    Message message,
  }) {
    return Room(
      name: name ?? this.name,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [name, message];
}
