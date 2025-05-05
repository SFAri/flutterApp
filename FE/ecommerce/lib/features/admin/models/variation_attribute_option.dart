class VariationAttributeOption {
  final int id;
  final int variationId;
  final int attributeOptionId;

  VariationAttributeOption({
    required this.id,
    required this.variationId,
    required this.attributeOptionId,
  });

  factory VariationAttributeOption.fromJson(Map<String, dynamic> json) =>
    VariationAttributeOption(
      id: json['id'],
      variationId: json['variationId'],
      attributeOptionId: json['attributeOptionId'],
    );

  Map<String, dynamic> toJson() => {
    'id': id,
    'variationId': variationId,
    'attributeOptionId': attributeOptionId,
  };
}
