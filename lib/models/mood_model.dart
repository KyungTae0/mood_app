class MoodModel {
  String uid;
  DateTime createdAt;
  String emoji;
  String content;
  String? image;
  String? imageRef;

  MoodModel({
    required this.uid,
    required this.createdAt,
    required this.emoji,
    required this.content,
    required this.image,
    required this.imageRef,
  });

  // 생성자에서 Map을 이용하여 객체를 생성
  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      uid: json['uid'],
      createdAt: DateTime.parse(json['createdAt']),
      emoji: json['emoji'],
      content: json['content'],
      image: json['image'],
      imageRef: json['imageRef'],
    );
  }

  // 객체를 Map으로 변환
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'createdAt': createdAt.toIso8601String(),
      'emoji': emoji,
      'content': content,
      'image': image,
      'imageRef': imageRef,
    };
  }
}
