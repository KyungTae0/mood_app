import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sam_mood_app/models/mood_model.dart';

class MoodCardWidget extends StatelessWidget {
  const MoodCardWidget({
    super.key,
    required this.docId,
    required this.mood,
    required this.deleteDoc,
  });

  final MoodModel mood;
  final String docId;
  final void Function(String, String) deleteDoc;

  // DateTime을 요일 형식으로 포맷팅
  String formattedDay(DateTime date) {
    // DateTime을 요일 형식으로 포맷팅
    String formattedDay = DateFormat('EEEE').format(date);

    // 결과 출력
    return formattedDay; // 출력: 금요일
  }

  /// DateTime을 월 일 형식으로 포맷팅
  String fommatingDate(DateTime date) {
    // DateTime을 원하는 형식으로 포맷팅
    String formattedDate = DateFormat('MM월 dd일').format(date);

    // 결과 출력
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Text(
                    mood.emoji,
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  title: Text(
                    fommatingDate(
                      mood.createdAt,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(formattedDay(mood.createdAt)),
                  trailing: mood.imageRef != null
                      ? IconButton(
                          onPressed: () {
                            deleteDoc(docId, mood.imageRef!);
                          },
                          icon: const Icon(
                            Icons.delete_outlined,
                            size: 20,
                          ),
                        )
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 21,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (mood.image != "")
                        Column(
                          children: [
                            Image.network(
                              mood.image!,
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 200,
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      Text(
                        mood.content,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}
