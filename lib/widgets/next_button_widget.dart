import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color.fromARGB(210, 210, 210, 210),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        color: const Color.fromARGB(210, 210, 210, 210),
        icon: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ), // 아이콘 색상을 흰색으로 설정
        onPressed: onPressed,
      ),
    );
  }
}
