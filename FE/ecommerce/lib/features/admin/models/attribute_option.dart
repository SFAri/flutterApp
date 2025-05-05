class AttributeOption {
  final int id;
  final int attributeId;
  final String value; // Ví dụ: 'Black', '8GB'

  AttributeOption({required this.id, required this.attributeId, required this.value});

  factory AttributeOption.fromJson(Map<String, dynamic> json) => AttributeOption(
    id: json['id'],
    attributeId: json['attributeId'],
    value: json['value'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'attributeId': attributeId,
    'value': value,
  };
}
