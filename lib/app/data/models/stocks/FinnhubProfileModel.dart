class FinnhubProfileModel {
  final String logo;
  final String name;

  FinnhubProfileModel({required this.logo, required this.name});

  factory FinnhubProfileModel.fromJson(Map<String, dynamic> json) {
    return FinnhubProfileModel(
      logo: json['logo'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
