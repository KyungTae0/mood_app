import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sam_mood_app/widgets/emoji_card_row_widget.dart';
import 'package:sam_mood_app/widgets/next_button_widget.dart';

class SelectEmotionScreen extends StatefulWidget {
  SelectEmotionScreen({
    super.key,
    required this.firestore,
    required this.setPageIndex,
    required this.setEmoji,
  });

  final FirebaseFirestore firestore;
  void Function(int) setPageIndex;
  void Function(String) setEmoji;
  @override
  State<SelectEmotionScreen> createState() => _SelectEmotionScreenState();
}

class _SelectEmotionScreenState extends State<SelectEmotionScreen> {
  String emojiData = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 60,
          ),
          alignment: Alignment.center,
          child: const Text(
            "오늘의 기분은 어떠셨나요?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: widget.firestore.collection('emotions').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final emotions = snapshot.data!.docs;

              List<Widget> emojiCards = [];
              for (var emotion in emotions) {
                String emoji = emotion.get('emoji');
                emojiCards.add(
                  Stack(
                    children: [
                      InkWell(
                        child: Text(
                          emotion.get('emoji'),
                          style: const TextStyle(
                            fontSize: 50,
                          ),
                        ),
                        onTap: () => {
                          setState(
                            () {
                              emojiData = emoji;
                            },
                          )
                        },
                      ),
                      if (emojiData == emoji)
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
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: (emojiCards.length / 3).ceil(),
                  itemBuilder: (context, index) {
                    int startIndex = index * 3;
                    int endIndex = (index + 1) * 3;
                    if (endIndex > emojiCards.length) {
                      endIndex = emojiCards.length;
                    }

                    return EmojiCardRow(
                        emojiCards.sublist(startIndex, endIndex));
                  },
                ),
              );
            } else {
              return const Center(
                //로딩바 구현 부분
                child: SpinKitFadingCube(
                  // FadingCube 모양 사용
                  color: Colors.purple, // 색상 설정
                  size: 50.0, // 크기 설정
                  duration: Duration(seconds: 2), //속도 설정
                ),
              );
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 25,
          ),
          child: NextButton(onPressed: () {
            if (emojiData.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('에러'),
                    content: const Text('선택된 이모지가 없어요!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  );
                },
              );

              return;
            }
            widget.setEmoji(emojiData);
            widget.setPageIndex(1);
          }),
        ),
      ],
    );
  }
}
