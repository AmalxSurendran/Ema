import 'dart:convert';

List<FAQ> faqFromJson(String str) => List<FAQ>.from(json.decode(str).map((x) => FAQ.fromJson(x)));

class FAQ {
  FAQ({
    required this.question,
    required this.answer,
  });

  String question;
  String answer;

  factory FAQ.fromJson(Map<String, dynamic> json) => FAQ(
    question: json["question"],
    answer: json["answer"],
  );
}