class AuthenticationValidator{
  static final AuthenticationValidator _instance = AuthenticationValidator._internal();
  factory AuthenticationValidator() => _instance;
  AuthenticationValidator._internal();

  // Email validation
  static bool isEmailValid(String? email){
    if(email == null || email.isEmpty){
      return false;
    }
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  // Phone validation
  static bool isPhoneValid(String? phone){
    if(phone == null || phone.isEmpty){
      return false;
    }
    return phone.trim().length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone.trim());
  }

  // Password validation
  static bool isPasswordValid(String? password){
    if(password == null || password.isEmpty){
      return false;
    }
    return RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password);
  }

  // Username validation
  static bool isUsernameValid(String? username){
    if(username == null || username.isEmpty){
      return false;
    }
    return username.trim().length >= 3 && RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(username.trim());
  }

  // Empty validation
  static bool isFieldEmpty(String? value){
    return value == null || value.isEmpty;
  }

  // Form authentication validation
  static Map<String, String> validateForm({
    String? email,
    String? password,
    String? phone,
    String? username,
    bool isRegistration = false,
    bool isForgotPassword = false
  }){
    Map<String, String> errors = {};

    // Validate email
    if(isFieldEmpty(email)){
      errors['email'] = 'Vui lòng nhập email';
    } else if(!isEmailValid(email)){
      errors['email'] = 'Email không hợp lệ';
    }

    // Validate password
    if(!isForgotPassword){
      if(isFieldEmpty(password)){
        errors['password'] = 'Vui lòng nhập mật khẩu';
      } else if(!isPasswordValid(password)){
        errors['password'] = 'Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số';
      }
    }

    // Validate phone
    if(isRegistration){
      if(isFieldEmpty(phone)){
        errors['phone'] = 'Vui lòng nhập số điện thoại';
      } else if(!isPhoneValid(phone)){
        errors['phone'] = 'Số điện thoại không hợp lệ';
      }

      // Validate username
      if(isFieldEmpty(username)){
        errors['username'] = 'Vui lòng nhập tên đăng nhập';
      } else if(!isUsernameValid(username)){
        errors['username'] = 'Tên đăng nhập phải chứa ít nhất 3 ký tự và không chứa ký tự đặc biệt';
      }
    }
    return errors;
  }

  static String getErrorMessage(Map<String, String> errors){
    if(errors.isEmpty){
      return '';
    }
    return errors.values.first;
  }
}