class Contact {
  final String name;
  final String company;
  final String phone;
  final String email;
  final String website;
  final String? address;
  final DateTime createdAt;

  const Contact({
    required this.name,
    required this.company,
    required this.phone,
    required this.email,
    required this.website,
    this.address,
    required this.createdAt,
  });
}