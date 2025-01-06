import 'package:app/services/AppointmentService.dart';
import 'package:app/services/NotificationService.dart';
// import 'package:app/services/NotificationService.dart';
import 'package:app/services/NotifyService.dart';
import 'package:app/services/ProvinceGHNApiService.dart';
import 'package:app/services/StorageService.dart';
import 'package:app/ui/screens/BookingSuccessScreen.dart';
import 'package:app/ui/widgets/AddressDropdownField.dart';
import 'package:app/ui/widgets/ButtonWidget.dart';
import 'package:app/ui/widgets/DateTimePickerWidget.dart';
import 'package:app/ui/widgets/DoctorInfoWidget.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:app/ui/widgets/RadioButtonWidget.dart';
import 'package:app/ui/widgets/TextFieldWidget.dart';
import 'package:app/utils/appointment_validator.dart';
import 'package:app/utils/auth_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/schedule.dart';
import '../../models/user.dart';
import '../../styles/colors.dart';
import '../../styles/text.dart';
import '../../utils/date_time.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Widget previousScreen;
  final String doctorId;
  final Schedule schedule;
  final String doctorName;
  final String doctorImage;
  final String price;

  const AppointmentDetailScreen({
    super.key,
    required this.previousScreen,
    required this.doctorId,
    required this.schedule,
    required this.doctorName,
    required this.doctorImage,
    required this.price,
  });

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientPhoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Address Selection
  Map<String, dynamic>? _selectedProvince;
  Map<String, dynamic>? _selectedDistrict;
  Map<String, dynamic>? _selectedWard;

  Map<String, dynamic>? _originalProvince;
  Map<String, dynamic>? _originalDistrict;
  Map<String, dynamic>? _originalWard;

  // Form State
  DateTime? _selectedDate;
  Gender _selectedGender = Gender.male;
  SingingCharacter _bookingType = SingingCharacter.SELF_BOOKING;
  bool _isLoading = false;
  bool _isAddressLoaded = false;
  String? _error;

  // Services
  late Future<AppointmentService> _appointmentService;
  UserData? _currentUser;
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _appointmentService = AppointmentService.create();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final storageService = await StorageService.getInstance();
      _currentUser = await storageService.getUserDataFromToken();

      if (_currentUser != null) {
        setState(() {
          // Fill thông tin người đặt/bệnh nhân dựa vào loại đặt lịch
          _updateFormFields();
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Cập nhật hàm _updateFormFields để không khóa trường ngày sinh
  void _updateFormFields() {
    if (_currentUser == null) return;

    setState(() {
      if(_bookingType == SingingCharacter.SELF_BOOKING){
        _updateSelfBookingFields();
      } else {
        _updateOtherBookingFields();
      }
    });
  }

  void _updateSelfBookingFields() {
    // Clear thông tin người đặt vì tự đặt không cần
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();

    // Cập nhật thông tin bệnh nhân từ currentUser
    _patientNameController.text = _currentUser?.username ?? '';
    _patientPhoneController.text = _currentUser?.phone ?? '';

    if (_currentUser?.dateOfBirth != null) {
      _selectedDate = DateTime.parse(_currentUser!.dateOfBirth!);
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }

    if (_currentUser?.gender != null) {
      _selectedGender = _currentUser!.gender?.toLowerCase() == 'nam'
          ? Gender.male
          : Gender.female;
    }

    // Khôi phục địa chỉ đã lưu
    if (_originalProvince != null && _originalDistrict != null && _originalWard != null) {
      setState(() {
        _selectedProvince = Map<String, dynamic>.from(_originalProvince!);
        _selectedDistrict = Map<String, dynamic>.from(_originalDistrict!);
        _selectedWard = Map<String, dynamic>.from(_originalWard!);
      });
    } else if (_currentUser?.address != null && _currentUser!.address!.isNotEmpty) {
      // Reset flag để cho phép xử lý địa chỉ lại
      _isAddressLoaded = false;
      _processAddress(_currentUser!.address!);
    }
  }

  void _updateOtherBookingFields() {
    // Lưu trữ địa chỉ hiện tại nếu có
    if (_selectedProvince != null && _selectedDistrict != null && _selectedWard != null) {
      _originalProvince = Map<String, dynamic>.from(_selectedProvince!);
      _originalDistrict = Map<String, dynamic>.from(_selectedDistrict!);
      _originalWard = Map<String, dynamic>.from(_selectedWard!);
    }

    // Cập nhật thông tin người đặt từ currentUser
    _nameController.text = _currentUser?.username ?? '';
    _phoneController.text = _currentUser?.phone ?? '';
    _emailController.text = _currentUser?.email ?? '';

    // Clear thông tin bệnh nhân
    _patientNameController.clear();
    _patientPhoneController.clear();
    _dateController.clear();
    _selectedDate = null;
    _selectedGender = Gender.male;

    // Clear địa chỉ
    setState(() {
      _selectedProvince = null;
      _selectedDistrict = null;
      _selectedWard = null;
    });
  }

  Future<void> _processAddress(String fullAddress) async {
    try {
      if(_isAddressLoaded) return;

      final addressParts = fullAddress.split(', ');
      if (addressParts.length < 3) return;

      final provinces = await ProvinceGHNApiService.getProvinces();
      final province = provinces.firstWhere(
            (p) => p['ProvinceName'] == addressParts[2],
        orElse: () => {},
      );

      if (province.isEmpty) return;

      setState(() {
        _selectedProvince = province;
        _originalProvince = Map<String, dynamic>.from(province);
      });

      final districts = await ProvinceGHNApiService.getDistricts(province['ProvinceID']);
      final district = districts.firstWhere(
            (d) => d['DistrictName'] == addressParts[1],
        orElse: () => {},
      );

      if (district.isEmpty) return;

      setState(() {
        _selectedDistrict = district;
        _originalDistrict = Map<String, dynamic>.from(district);
      });

      final wards = await ProvinceGHNApiService.getWards(district['DistrictID']);
      final ward = wards.firstWhere(
            (w) => w['WardName'] == addressParts[0],
        orElse: () => {},
      );

      if (ward.isNotEmpty) {
        setState(() {
          _selectedWard = ward;
          _originalWard = Map<String, dynamic>.from(ward);
          _isAddressLoaded = true;
        });
      }
    } catch (e) {
      print('Error processing address: $e');
    }
  }

  Future<void> _createAppointment() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final appointmentService = await _appointmentService;
      _userData = _createUserData();

      if (_userData != null) {
        final appointment = await appointmentService.createAppointment(
          doctorId: widget.doctorId,
          schedule: widget.schedule,
          user: _userData!,
          type: _bookingType.name,
        );

        if (_bookingType == SingingCharacter.OTHER_BOOKING) {
          await NotificationService.sendImmediateNotification(
            title: 'Đặt lịch thành công',
            description: 'Bạn đã đặt lịch khám cho người thân với Bác sĩ ${widget.doctorName} '
                'vào lúc ${DateTimeUtils.formatScheduleTimeRange(widget.schedule)} '
                'ngày ${DateTimeUtils.formatDate(DateTime.parse(widget.schedule.workingDate!))}',
            additionalData: {
              'type': 'appointment_created_for_other',
              'appointmentId': appointment.id,
              'doctorName': widget.doctorName,
            },
          );
        } else {
          await NotificationService.sendImmediateNotification(
            title: 'Đặt lịch thành công',
            description: 'Bạn đã đặt lịch khám thành công với Bác sĩ ${widget.doctorName} '
                'vào lúc ${DateTimeUtils.formatScheduleTimeRange(widget.schedule)} '
                'ngày ${DateTimeUtils.formatDate(DateTime.parse(widget.schedule.workingDate!))}',
            additionalData: {
              'type': 'appointment_created',
              'appointmentId': appointment.id,
              'doctorName': widget.doctorName,
            },
          );
        }

        // Đặt lịch nhắc nhở trước 1 giờ
        // await NotificationService.sheduleAppointmentReminder(
        //   appointmentId: appointment.id ?? '',
        //   patientName: _userData!.username ?? '',
        //   doctorName: widget.doctorName,
        //   appointmentTime: DateTime.parse('${widget.schedule.workingDate!} ${widget.schedule.startTime!}'),
        // );

        // await NotifyService().sendNotification(
        //   'Đặt lịch thành công',
        //   'Bạn đã đặt lịch khám thành công với bác sĩ ${widget.doctorName} vào lúc ${DateTimeUtils.formatScheduleTimeRange(widget.schedule)} ngày ${DateTimeUtils.formatDate(DateTime.parse(widget.schedule.workingDate!))}',
        // );

        if (mounted) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => const BookingSuccessScreen()),
          );
        }
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  UserData _createUserData() {
    // Ensure address is properly constructed
    final addressField = [
      _selectedWard?['WardName'],
      _selectedDistrict?['DistrictName'],
      _selectedProvince?['ProvinceName']
    ].whereType<String>().join(', ');

    // Add null safety for date of birth
    String? dateOfBirthField;
    if (_selectedDate != null) {
      dateOfBirthField = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    } else if (_currentUser?.dateOfBirth != null && _currentUser!.dateOfBirth!.isNotEmpty) {
      // Try to parse existing date if available
      try {
        final DateTime parsedDate = DateTime.parse(_currentUser!.dateOfBirth!);
        dateOfBirthField = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        print('Error parsing existing date of birth: $e');
        // Don't set dateOfBirthField if parsing fails
      }
    }

    // Ensure date of birth is not null before creating UserData
    if (dateOfBirthField == null) {
      throw FormatException('Date of birth is required');
    }

    // Ensure gender is properly formatted
    final genderField = _selectedGender == Gender.male ? "Nam" : "Nữ";

    if (_bookingType == SingingCharacter.SELF_BOOKING) {
      return UserData(
        id: _currentUser?.id,
        username: _patientNameController.text.isNotEmpty ?
        _patientNameController.text : _currentUser?.username,
        phone: _patientPhoneController.text.isNotEmpty ?
        _patientPhoneController.text : _currentUser?.phone,
        email: _currentUser?.email,
        address: addressField.isNotEmpty ? addressField : _currentUser?.address,
        dateOfBirth: dateOfBirthField, // Use the safely processed date
        gender: genderField,
      );
    } else {
      return UserData(
        id: _currentUser?.id,
        username: _patientNameController.text,
        phone: _patientPhoneController.text,
        email: _currentUser?.email,
        address: addressField,
        dateOfBirth: dateOfBirthField,
        gender: genderField,
      );
    }
  }

  bool _validateForm() {
    final errors = AppointmentValidator.validateAppointmentForm(
      isOtherBooking: _bookingType == SingingCharacter.OTHER_BOOKING,
      patientName: _patientNameController.text,
      patientPhone: _patientPhoneController.text,
      dateOfBirth: _selectedDate,
      province: _selectedProvince,
      district: _selectedDistrict,
      ward: _selectedWard,
    );

    if (errors.isNotEmpty) {
      setState(() => _error = AppointmentValidator.getErrorMessage(errors));
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HeaderWidget(
              isHomeScreen: false,
              onIconPressed: () => Navigator.pop(
                context,
                CupertinoPageRoute(builder: (context) => widget.previousScreen),
              ),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildBackground(),
                  _buildContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background_3.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        Column(
          children: [
            _buildBreadcrumb(),
            _buildDivider(),
            const SizedBox(height: 10),
            _buildMainContent(),
          ],
        ),
      ],
    );
  }

  Widget _buildBreadcrumb() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.home, color: AppColors.primaryBlue),
          Text(" / ", style: TextStyle(fontSize: 18, color: Colors.grey)),
          Expanded(
            child: Text(
              "Đặt lịch khám bệnh",
              style: AppTextStyles.subHeaderStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.primaryBlue,
      width: double.infinity,
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: DoctorInfoWidget(
            name: widget.doctorName,
            imageUrl: widget.doctorImage,
            date: DateTimeUtils.formatDate(DateTime.parse(widget.schedule.workingDate!)),
            time: DateTimeUtils.formatScheduleTimeRange(widget.schedule),
            price: widget.price,
          ),
        ),
        TypeSelectorWidget(
          character: _bookingType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _bookingType = value;
                // Clear tất cả các controller trước khi cập nhật form mới
                _nameController.clear();
                _phoneController.clear();
                _emailController.clear();
                _patientNameController.clear();
                _patientPhoneController.clear();
                _dateController.clear();
                _selectedDate = null;
                _selectedGender = Gender.male;
                _selectedProvince = null;
                _selectedDistrict = null;
                _selectedWard = null;
              });
              // Gọi updateFormFields sau khi đã clear các trường
              _updateFormFields();
            }
          },
        ),
        if (_bookingType == SingingCharacter.OTHER_BOOKING) _buildBookerInfo(),
        _buildPatientInfo(),
        if (_error != null) _buildErrorMessage(),
        _buildFooterContent(),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        _error!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildFooterContent() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'Vui lòng điền đầy đủ thông tin, để tiết kiệm thời gian làm thủ tục khám bệnh',
            style: AppTextStyles.infoStyle,
          ),
        ),
        const SizedBox(height: 20),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else
          CustomElevatedButton(
            text: 'Đặt lịch ngay',
            onPressed: _createAppointment,
          ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildBookerInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 18, bottom: 5),
          child: Text(
            'Thông tin người đặt',
            style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        TextFieldWidget(
          controller: _nameController,
          hintText: 'Họ và tên',
          prefixIcon: Icons.person_outline,
          enabled: false,
        ),
        SizedBox(height: 10),
        TextFieldWidget(
          controller: _phoneController,
          hintText: 'Số điện thoại',
          prefixIcon: Icons.phone_outlined,
          enabled: false,
        ),
        SizedBox(height: 10),
        TextFieldWidget(
          controller: _emailController,
          hintText: 'Email',
          prefixIcon: Icons.email_outlined,
          enabled: false,
        ),
        SizedBox(height: 20),
      ],
    );
  }
  Widget _buildPatientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 5),
          child: Text(
            _bookingType == SingingCharacter.SELF_BOOKING
                ? 'Thông tin bệnh nhân'
                : 'Thông tin người thân',
            style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        TextFieldWidget(
          controller: _patientNameController,
          hintText: 'Họ tên bệnh nhân',
          prefixIcon: Icons.person_outline,
          isRequired: true,
          helperText: 'Hãy ghi rõ họ và tên, viết hoa những chữ cái đầu tiên.\nVí dụ: Nguyễn Văn A',
          enabled: true,
          readOnly: _bookingType == SingingCharacter.SELF_BOOKING && _currentUser?.username != null,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: GenderSelectorWidget(
            selectedGender: _selectedGender,
            onChanged: (Gender value) {
              setState(() {
                _selectedGender = value; // Update selected gender
              });
            },
            enabled: true,
            readOnly: _bookingType == SingingCharacter.SELF_BOOKING && _currentUser?.gender != null,
          ),
        ),
        TextFieldWidget(
          controller: _patientPhoneController,
          hintText: 'Số điện thoại bệnh nhân',
          prefixIcon: Icons.phone_outlined,
          isRequired: true,
          enabled: true,
          readOnly: _bookingType == SingingCharacter.SELF_BOOKING && _currentUser?.phone != null,
        ),
        const SizedBox(height: 10),
        DatePickerTextField(
          controller: _dateController,
          hintText: 'Ngày/tháng/năm sinh',
          prefixIcon: Icons.calendar_today_outlined,
          initialDate: _selectedDate,
          isRequired: true,
          onDateSelected: (DateTime selectedDate) {
            setState(() {
              _selectedDate = selectedDate;
            });
          },
          enabled: true,
          readOnly: _bookingType == SingingCharacter.SELF_BOOKING && _currentUser?.dateOfBirth != null,
        ),
        const SizedBox(height: 10),
        AddressDropdownField(
          key: ValueKey('province-${_selectedProvince?.toString()??''}'),
          hintText: 'Chọn tỉnh/thành phố',
          prefixIcon: Icons.location_on_outlined,
          isRequired: true,
          initialValue: _selectedProvince,
          fetchItems: ProvinceGHNApiService.getProvinces,
          onChanged: (value) {
            setState(() {
              _selectedProvince = value;
              _selectedDistrict = null;
              _selectedWard = null;
            });
          },
          enabled: true, // Luôn bật để hiển thị dữ liệu
          readOnly: _bookingType == SingingCharacter.SELF_BOOKING && _currentUser?.address != null, // Không cho chọn nếu là SELF_BOOKING
        ),
        const SizedBox(height: 10),
        AddressDropdownField(
          key: ValueKey('district-${_selectedDistrict?.toString() ?? ''}-${_selectedProvince?.toString() ?? ''}'),
          hintText: 'Chọn quận/huyện',
          prefixIcon: Icons.location_on_outlined,
          isRequired: true,
          initialValue: _selectedDistrict,
          fetchItems: () => _selectedProvince != null
              ? ProvinceGHNApiService.getDistricts(_selectedProvince!['ProvinceID'])
              : Future.value([]),
          onChanged: (value) {
            setState(() {
              _selectedDistrict = value;
              _selectedWard = null;
            });
          },
          enabled: true, // Luôn bật để hiển thị dữ liệu
          readOnly: _bookingType == SingingCharacter.SELF_BOOKING && _currentUser?.address != null, // Không cho chọn nếu là SELF_BOOKING
        ),
        const SizedBox(height: 10),
        AddressDropdownField(
          key: ValueKey('ward-${_selectedWard?.toString() ?? ''}-${_selectedDistrict?.toString() ?? ''}'),
          hintText: 'Chọn phường/xã',
          prefixIcon: Icons.location_on_outlined,
          isRequired: true,
          initialValue: _selectedWard,
          fetchItems: () => _selectedDistrict != null
              ? ProvinceGHNApiService.getWards(_selectedDistrict!['DistrictID'])
              : Future.value([]),
          onChanged: (value) {
            setState(() {
              _selectedWard = value;
            });
          },
          enabled: true, // Luôn bật để hiển thị dữ liệu
          readOnly: _bookingType == SingingCharacter.SELF_BOOKING && _currentUser?.address != null, // Không cho chọn nếu là SELF_BOOKING
        ),
      ],
    );
  }
}