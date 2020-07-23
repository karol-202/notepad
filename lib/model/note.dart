class Note {
  final String id;
  final String title;
  final String content;

  const Note({
    this.id = '',
    this.title = '',
    this.content = '',
  });

  factory Note.fromJson(String id, Map<String, dynamic> json) => Note(
        id: id,
        title: json['title'],
        content: json['content'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };

  Note copy({
    String id,
    String title,
    String content,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
      );
}
