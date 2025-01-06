class AuthenticationRequest{
  AuthenticationRequest({
    required this.email,
    this.password,
    this.phone,
    this.username,
    this.role = 1
  });

  final String email;
  final String? password;
  final String? phone;
  final String? username;
  final int role;

  factory AuthenticationRequest.login({
    required String email,
    required String password,
  }) {
    return AuthenticationRequest(
      email: email,
      password: password,
    );
  }

  factory AuthenticationRequest.register({
    required String email,
    required String password,
    required String username,
    required String phone,
    int role = 1
  }) {
    return AuthenticationRequest(
      email: email,
      password: password,
      username: username,
      phone: phone,
      role: role
    );
  }

  factory AuthenticationRequest.forgotPassword({
    required String email,
  }) {
    return AuthenticationRequest(
      email: email,
    );
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    if(username != null){
      data['username'] = username;
    }
    if(phone != null){
      data['phone'] = phone;
    }
    if(role != 1){
      data['role'] = role;
    }
    return data;
  }
}