class User {
  int? id;
  String fullName;
  String nik;
  String email;
  String address;
  String phone;
  String username;
  String password;

  User({
    this.id,
    required this.fullName,
    required this.nik,
    required this.email,
    required this.address,
    required this.phone,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'nik': nik,
      'email': email,
      'address': address,
      'phone': phone,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['fullName'],
      nik: map['nik'],
      email: map['email'],
      address: map['address'],
      phone: map['phone'],
      username: map['username'],
      password: map['password'],
    );
  }
}
