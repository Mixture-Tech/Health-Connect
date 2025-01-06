class AppointmentValidator {
  static final AppointmentValidator _instance = AppointmentValidator._internal();
  factory AppointmentValidator() => _instance;
  AppointmentValidator._internal();

  // Name validation
  static bool isNameValid(String? name) {
    if (name == null || name.isEmpty) {
      return false;
    }
    // Tên phải có ít nhất 3 ký tự và chỉ chứa chữ cái, khoảng trắng
    return name.trim().length >= 3 && RegExp(r'^[a-zA-ZÀ-ỹ ]+$').hasMatch(name.trim());
  }

  // Phone validation - giống như AuthenticationValidator
  static bool isPhoneValid(String? phone) {
    if (phone == null || phone.isEmpty) {
      return false;
    }
    return phone.trim().length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone.trim());
  }

  // Email validation - giống như AuthenticationValidator
  static bool isEmailValid(String? email) {
    if (email == null || email.isEmpty) {
      return false;
    }
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  // Date validation
  static bool isDateValid(DateTime? date) {
    if (date == null) return false;

    final now = DateTime.now();
    final minDate = DateTime(1900, 1, 1);

    return date.isAfter(minDate) && date.isBefore(now);
  }

  // Empty validation
  static bool isFieldEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.trim().isEmpty;
    return false;
  }

  // Address validation
  static bool isAddressValid(Map<String, dynamic>? province, Map<String, dynamic>? district, Map<String, dynamic>? ward) {
    return province != null && district != null && ward != null;
  }

  // Form validation
  static Map<String, String> validateAppointmentForm({
    required bool isOtherBooking,
    String? bookerName,
    String? bookerPhone,
    String? bookerEmail,
    String? patientName,
    String? patientPhone,
    DateTime? dateOfBirth,
    Map<String, dynamic>? province,
    Map<String, dynamic>? district,
    Map<String, dynamic>? ward,
  }) {
    Map<String, String> errors = {};
    // Validate thông tin bệnh nhân
    if (isFieldEmpty(patientName)) {
      errors['patientName'] = 'Vui lòng nhập họ tên bệnh nhân';
    } else if (!isNameValid(patientName)) {
      errors['patientName'] = 'Họ tên bệnh nhân không hợp lệ';
    }

    if (isFieldEmpty(patientPhone)) {
      errors['patientPhone'] = 'Vui lòng nhập số điện thoại bệnh nhân';
    } else if (!isPhoneValid(patientPhone)) {
      errors['patientPhone'] = 'Số điện thoại bệnh nhân không hợp lệ';
    }

    if (!isDateValid(dateOfBirth)) {
      errors['dateOfBirth'] = 'Vui lòng chọn ngày sinh';
    }

    // Validate địa chỉ
    if (!isAddressValid(province, district, ward)) {
      errors['address'] = 'Vui lòng chọn đầy đủ thông tin địa chỉ';
    }

    return errors;
  }

  // Lấy thông báo lỗi
  static String getErrorMessage(Map<String, String> errors) {
    if (errors.isEmpty) {
      return '';
    }
    return errors.values.first;
  }
}