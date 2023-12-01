import 'package:flutter/material.dart';

class EmojiCardRow extends StatelessWidget {
  final List<Widget> emojiCards;

  const EmojiCardRow(this.emojiCards, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: emojiCards,
      ),
    );
  }
}
