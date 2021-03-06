import 'package:flutter/material.dart';
import 'package:tada_team_chat/sevices/logger.dart';

class ChatLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Лог чата'),
      ),
      body: ListView(
        children:
            ChatLogger().memoryOutput.buffer.map((element) => Text(element.lines.join())).toList(),
      ),
    );
  }
}
