import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    this.created,
    this.text,
    this.name,
    this.isMe,
    this.key,
  });

  final Key key;
  final String created;
  final String text;
  final String name;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Wrap(
            alignment: isMe ? WrapAlignment.end : WrapAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      isMe ? Theme.of(context).accentColor : Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.black : Colors.orangeAccent,
                      ),
                    ),
                    Text(
                      '$text',
                      style: TextStyle(
                        color: isMe ? Colors.black : Colors.grey[900],
                      ),
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
