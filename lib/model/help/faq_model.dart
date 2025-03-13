class FaqModel {
  final String question;
  final String answer;

  FaqModel({required this.question, required this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        question: json['question']?.toString() ?? '',
        answer: json['answer']?.toString() ?? '',
      );
}
