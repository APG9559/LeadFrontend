class Lead {
  String firstName;
  String lastName;
  String? email;
  String? phone;

  Lead({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
    };
  }
}
