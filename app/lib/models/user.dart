class UserData {
  final String? id;
  final String? email;
  final String? username;
  final String? phone;
  final String? address;
  final String? dateOfBirth; // Changed to String with format "yyyy-MM-dd"
  final String? gender;
  final bool? isActive;

  UserData({
    this.id,
    this.email,
    this.username,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.isActive,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
        return UserData(
    id: json['id'],
        email: json['email'],
        username: json['username'],
        phone: json['phone'],
        address: json['address'],
        dateOfBirth: json['dateOfBirth'].toString(),
        gender: json['gender'],
        isActive: json['isActive']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'isActive': isActive,
    };
  }
}