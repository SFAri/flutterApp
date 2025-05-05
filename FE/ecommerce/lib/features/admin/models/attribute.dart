class Attribute {
  final int id;
  final String name; // Ví dụ: 'Color', 'RAM'

  Attribute({required this.id, required this.name});

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
