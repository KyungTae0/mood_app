import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sam_mood_app/widgets/emoji_card_row_widget.dart';
import 'package:sam_mood_app/widgets/emoji_card_widget.dart';
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

  /// 이모지 넣어주기
  void setEmoji(String emoji) {
    setState(
      () {
        emojiData = emoji;
      },
    );
  }

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

        /// Stream에의해 새로 build 해야할일이 생기면 알아서 listen해서 효율적으로 re build해주는 위젯이다
        /// QuerySnapshot -> stream 에 의해 받는 데이터 형태
        StreamBuilder<QuerySnapshot>(
          stream: widget.firestore.collection('emotions').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final emotions = snapshot.data!.docs;

              List<Widget> emojiCards = [];
              for (var emotion in emotions) {
                String emoji = emotion.get('emoji');
                emojiCards.add(
                  // 이모지 카드 한건 한건 추가
                  EmojiCardWidget(
                    emoji: emoji,
                    emojiData: emojiData,
                    setEmoji: setEmoji,
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

                    // 이모지 카드 뿌리기
                    return EmojiCardRow(
                        // 한줄에 3개씩 뿌림
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
            // 선택한 이모지 넣어 다음페이지에 전달
            widget.setEmoji(emojiData);
            // 부모 Post Screen의 페이지 인덱스를 변경하여 다음페이지로 이동
            widget.setPageIndex(1);
          }),
        ),
      ],
    );
  }
}
