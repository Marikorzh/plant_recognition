final String tableSaves = 'notes'; // назва таблиці

class SaveFields { //назва усіх стовбиців у типі String
  static final List<String> values = [
    /// Add all fields
    id, isImportant, clas, title, path, time
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String clas = 'clas';
  static final String title = 'title';
  static final String path = 'path';
  static final String time = 'time';
}


class Save { // клас із даними та їх обробкою
  final int? id;
  final bool isImportant;
  final String clas;
  final String title;
  final String path;
  final DateTime createdTime;

  const Save({
    this.id,
    required this.isImportant,
    required this.clas,
    required this.title,
    required this.path,
    required this.createdTime,
  });

  // копіювання
  Save copy({
    int? id,
    bool? isImportant,
    String? clas,
    String? title,
    String? path,
    DateTime? createdTime,
  }) =>
      Save(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        clas: clas ?? this.clas,
        title: title ?? this.title,
        path: path ?? this.path,
        createdTime: createdTime ?? this.createdTime,
      );

  // перевод з типу JSON у інші типи
  static Save fromJson(Map<String, Object?> json) => Save(
    id: json[SaveFields.id] as int?,
    isImportant: json[SaveFields.isImportant] == 1,
    clas: json[SaveFields.clas] as String,
    title: json[SaveFields.title] as String,
    path: json[SaveFields.path] as String,
    createdTime: DateTime.parse(json[SaveFields.time] as String),
  );

  // перевод з інших типів у JSON
  Map<String, Object?> toJson() => {
    SaveFields.id: id,
    SaveFields.title: title,
    SaveFields.isImportant: isImportant ? 1 : 0,
    SaveFields.clas: clas,
    SaveFields.path: path,
    SaveFields.time: createdTime.toIso8601String(),
  };
}
