class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.title,
    this.isChecked = false,
  });

  final String id;
  final String title;
  final bool isChecked;

  ChecklistItem copyWith({
    String? id,
    String? title,
    bool? isChecked,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isChecked': isChecked,
    };
  }

  factory ChecklistItem.fromMap(Map<dynamic, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as String,
      title: map['title'] as String,
      isChecked: map['isChecked'] as bool? ?? false,
    );
  }
}
