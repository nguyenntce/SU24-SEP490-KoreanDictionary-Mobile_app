class Vocabulary {
  final int id;
  final String english;
  final String korean;
  final String vietnamese;
  final String image;
  final String voiceEn;
  final String voiceKr;
  final String voiceVn;

  Vocabulary({
    required this.id,
    required this.english,
    required this.korean,
    required this.vietnamese,
    required this.image,
    required this.voiceEn,
    required this.voiceKr,
    required this.voiceVn,
  });

  factory Vocabulary.fromMap(Map<dynamic, dynamic> data) {
    return Vocabulary(
      id: data['Id'],
      english: data['English'],
      korean: data['Korean'],
      vietnamese: data['Vietnamese'],
      image: data['Fruits_img'],
      voiceEn: data['Voice_EN'],
      voiceKr: data['Voice_KR'],
      voiceVn: data['Voice_VN'],
    );
  }
}