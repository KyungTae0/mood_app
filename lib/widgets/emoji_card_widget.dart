import 'package:flutter/material.dart';

class EmojiCardWidget extends StatefulWidget {
  final String emoji;
  final String emojiData;
  final void Function(String) setEmoji;

  const EmojiCardWidget({
    super.key,
    required this.emoji,
    required this.emojiData,
    required this.setEmoji,
  });

  @override
  State<EmojiCardWidget> createState() => _EmojiCardWidgetState();
}

class _EmojiCardWidgetState extends State<EmojiCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          child: Text(
            widget.emoji,
            style: const TextStyle(
              fontSize: 50,
            ),
          ),
          onTap: () {
            widget.setEmoji(widget.emoji);
          },
        ),
        if (widget.emojiData == widget.emoji)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  )),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
      ],
    );
  }
}
