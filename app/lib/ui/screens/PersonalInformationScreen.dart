import 'dart:convert';
import 'package:app/services/UserService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app/styles/colors.dart';
import 'package:app/ui/screens/ProfileScreen.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:app/ui/widgets/NavigationBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/ProvinceGHNApiService.dart';
import '../../services/StorageService.dart';
import '../widgets/AddressDropdownField.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/DateTimePickerWidget.dart';
import '../widgets/RadioButtonWidget.dart';
import '../widgets/TextFieldWidget.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _usernameController = TextEditingController();
  List<Map<String, dynamic>> provinces = []; // Danh sách tỉnh/thành phố
  List<Map<String, dynamic>> districts = []; // Danh sách quận/huyện
  List<Map<String, dynamic>> wards = []; // Danh sách phường/xã
  int? selectedProvinceId;
  int? selectedDistrictId;
  int? selectedWardId;
  bool isLoading = true;
  bool _isAddressLoaded = false;
  String username = ''; // Tên đầy đủ
  DateTime? dateOfBirth; // Ngày sinh
  Gender selectedGender = Gender.male;

  Map<String, dynamic>? _selectedProvince;
  Map<String, dynamic>? _selectedDistrict;
  Map<String, dynamic>? _selectedWard;

  Map<String, dynamic>? _originalProvince;
  Map<String, dynamic>? _originalDistrict;
  Map<String, dynamic>? _originalWard;

  UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _usernameController.text = username;
    _loadProvinces();// Gọi hàm để tải danh sách tỉnh
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final storageService = await StorageService.getInstance();
      _currentUser = await storageService.getUserDataFromToken();

      if (_currentUser != null) {
        setState(() {
          username = _currentUser?.username ?? '';
          _usernameController.text = username;

          final dobString = _currentUser?.dateOfBirth;
          if (dobString != null) {
            dateOfBirth = DateTime.tryParse(dobString);
          } else {
            dateOfBirth = _currentUser?.dateOfBirth as DateTime?;
          }

          final genderString = _currentUser?.gender ?? '';
          selectedGender = genderString == 'Nam' ? Gender.male : Gender.female;

          // Chỉ xử lý địa chỉ nếu chưa được load
          if (!_isAddressLoaded && _currentUser?.address != null && _currentUser!.address!.isNotEmpty) {
            _processAddress(_currentUser!.address!);
          }
        });
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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


  Future<void> _loadProvinces() async {
    try {
      final fetchedProvinces = await ProvinceGHNApiService.getProvinces();
      setState(() {
        provinces = fetchedProvinces;
      });
    } catch (e) {
      // Xử lý lỗi ở đây
      print('Error loading provinces: $e');
    }
  }

  Future<void> _submitPersonalInfo() async {
    try {
      const apiUrl = "http://10.0.2.2:8080/api";
      // Debug print để kiểm tra .env

      // Get the stored token
      final storageService = await StorageService.getInstance();
      final token = await storageService.getAccessToken();

      if (token == null || token.isEmpty) {
        throw Exception('Phiên đăng nhập đã hết hạn');
      }

      // Build the address string with null checks
      final address = "${_selectedWard!['WardName'] ?? ''}, "
          "${_selectedDistrict!['DistrictName'] ?? ''}, "
          "${_selectedProvince!['ProvinceName'] ?? ''}";

      // Build payload
      final Map<String, dynamic> payload = {
        'username': _usernameController.text.trim(),
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'gender': selectedGender == Gender.male ? 'Nam' : 'Nữ',
        'address': address,
      };

      // Debug print
      print('Debug: Sending request to: $apiUrl/user/update');
      print('Debug: Payload: $payload');

      // Make API call
      final response = await http.post(
        Uri.parse('$apiUrl/user/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thông tin cá nhân đã được lưu thành công!'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh user data after successful update
        await _fetchUserInfo();
      } else {
        if (!context.mounted) return;
        // Parse error message from response if available
        Map<String, dynamic>? errorBody;
        try {
          errorBody = jsonDecode(response.body);
        } catch (e) {
          print('Debug: Error parsing response body: $e');
        }

        final errorMessage = errorBody?['message'] ?? 'Đã xảy ra lỗi khi lưu thông tin!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Debug: Error in _submitPersonalInfo: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // Header
            HeaderWidget(
              isHomeScreen: false,
              onIconPressed: () {
                Navigator.pop(
                  context,
                  CupertinoPageRoute(builder: (context) => ProfileScreen()), // Chuyển đến trang hồ sơ
                );
              },
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Hình nền
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Background_3.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa các widget
                      children: [
                        SizedBox(height: 20),

                        // Hình đại diện
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/images/Personal_Avatar.png"),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái tất cả các mục
                          children: [
                            // Họ và tên
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Text(
                                'Họ và tên',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextFieldWidget(
                              hintText: 'Họ và tên',
                              prefixIcon: Icons.person_outline,
                              isRequired: true,
                              controller: _usernameController,
                            ),

                            // Ngày/tháng/năm sinh
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Text(
                                'Ngày/tháng/năm sinh',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DatePickerTextField(
                              hintText: 'Ngày/tháng/năm sinh',
                              prefixIcon: Icons.calendar_today_outlined,
                              isRequired: true,
                              initialDate: dateOfBirth, // Sử dụng dateOfBirth từ dữ liệu người dùng
                              onDateSelected: (DateTime selectedDate) {
                                setState(() {
                                  dateOfBirth = selectedDate; // Cập nhật ngày sinh
                                });
                              },
                            ),
                            const SizedBox(height: 10),

                            // Giới tính
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Text(
                                'Giới tính',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GenderSelectorWidget(
                              selectedGender: selectedGender,
                              onChanged: (Gender value) {
                                setState(() {
                                  selectedGender = value; // Cập nhật giá trị giới tính
                                });
                              },
                            ),

                            // Tỉnh
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Text(
                                'Tỉnh/Thành phố',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            AddressDropdownField(
                              key: ValueKey('province-${_selectedProvince?.toString() ?? ''}'),
                              hintText: 'Chọn tỉnh/thành phố',
                              prefixIcon: Icons.location_city,
                              isRequired: true,
                              initialValue: _selectedProvince,
                              fetchItems: () => ProvinceGHNApiService.getProvinces(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedProvince = value;
                                  _selectedDistrict = null; // Reset quận khi tỉnh thay đổi
                                  _selectedWard = null; // Reset phường khi tỉnh thay đổi
                                });
                              },
                              enabled: true,
                              readOnly: false,
                            ),
                            // Huyện
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Text(
                                'Quận/Huyện',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                                  _selectedWard = null; // Reset phường khi quận thay đổi
                                });
                              },
                              enabled: true,
                              readOnly: false,
                            ),

                            // Địa chỉ
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              child: Text(
                                'Phường/Xã',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            AddressDropdownField(
                              key: ValueKey('ward-${_selectedWard?.toString() ?? ''}-${_selectedDistrict?.toString() ?? ''}'),
                              hintText: 'Chọn phường/xã',
                              prefixIcon: Icons.location_on,
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
                              enabled: true,
                              readOnly: false,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Nút Lưu và Xem hồ sơ
                        CustomElevatedButton(text: 'Lưu', onPressed: _submitPersonalInfo),
                      ],
                    ),
                  ),
                  // NavigationBarWidget(),  // Navigation bar phía dưới
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}