import 'package:flutter/material.dart';

class Choix {
  final int id;
  final String textChoix;
  final int votes;
  final int questionId;

  Choix(
      {required this.questionId,
      required this.id,
      required this.textChoix,
      required this.votes});

  factory Choix.fromJson(Map<String, dynamic> json) {
    return Choix(
        id: json['id'],
        textChoix: json['choice_text'],
        votes: json['votes'],
        questionId: json['question']);
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'id: $id , choix: $textChoix';
  }
}
