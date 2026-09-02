import 'dart:ui';

class Company {
  final String name;
  final String type;
  final Color color;

  Company({
    required this.name,
    required this.type,
    required this.color,
  });
}


class CompanyFeature {
  final String name;
  final bool enabled;

  CompanyFeature(this.name, this.enabled);
}
