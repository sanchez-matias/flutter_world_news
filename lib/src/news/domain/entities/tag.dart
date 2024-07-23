class Tag {
  final int id;
  final String name;
  final bool isModifiable;

  Tag({
    required this.id,
    required this.name,
    required this.isModifiable,
  });

  Tag copyWith({
    int? id,
    String? name,
    bool? isModifiable,
  }) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        isModifiable: isModifiable ?? this.isModifiable,
      );
}
