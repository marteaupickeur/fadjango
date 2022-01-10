class Question {
  final int id;
  final String textQuestion;
  final String dateTime;

  Question({
    required this.id,
    required this.textQuestion,
    required this.dateTime,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'],
        textQuestion: json['question_text'],
        dateTime: json['pub_date']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id, question: $textQuestion';
  }
}
