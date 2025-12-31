import 'dart:convert';

class Entry {
  final int id;
  final String title;
  final String content;
  final DateTime date;

  Entry(
      {required this.id,
      required this.title,
      required this.content,
      required this.date});

  // MUDANÇA: Use Map para o serviço de arquivo funcionar
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'date': date.toIso8601String(),
      };

  // MUDANÇA: Aceita o Map vindo do JSON
  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        date: DateTime.parse(json['date']),
      );
}
