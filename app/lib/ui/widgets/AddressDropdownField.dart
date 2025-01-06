import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';
import 'package:app/styles/text.dart';

class AddressDropdownField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isRequired;
  final Future<List<Map<String, dynamic>>> Function() fetchItems;
  final Function(Map<String, dynamic>?) onChanged;
  final bool enabled;
  final bool readOnly;
  final Map<String, dynamic>? initialValue;

  const AddressDropdownField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.isRequired = false,
    required this.fetchItems,
    required this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.initialValue,
  }) : super(key: key);

  @override
  _AddressDropdownFieldState createState() => _AddressDropdownFieldState();
}

class _AddressDropdownFieldState extends State<AddressDropdownField> {
  Map<String, dynamic>? _selectedValue;
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _loadItems();
  }

  @override
  void didUpdateWidget(AddressDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedValue = widget.initialValue;
      });
    }

    if(oldWidget.fetchItems != widget.fetchItems) {
      _loadItems();
    }
  }

  Future<void> _loadItems() async {
    if (!widget.enabled) return;

    setState(() {
      _isLoading = true;
    });
    try {
      final items = await widget.fetchItems();
      if (mounted) {  // Check if widget is still mounted
        setState(() {
          _items = items;
          _isLoading = false;

          // Validate selected value still exists in new items
          if (_selectedValue != null) {
            final stillExists = items.any((item) =>
            _getDisplayText(item) == _getDisplayText(_selectedValue!));
            if (!stillExists) {
              _selectedValue = null;
              widget.onChanged(null);
            }
          }
        });
      }
    }catch(e){
      if (mounted) {
        setState(() {
          _isLoading = false;
          _items = [];
        });
      }
      print('Error loading items: $e');
    }
  }

  String _getDisplayText(Map<String, dynamic> item) {
    return item['ProvinceName'] ?? item['DistrictName'] ?? item['WardName'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: widget.enabled ? AppColors.white : AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5)
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedValue != null ? _getDisplayText(_selectedValue!) : null,
            icon: Icon(
                Icons.arrow_drop_down,
                color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5)
            ),
            hint: Row(
              children: [
                Icon(
                    widget.prefixIcon,
                    color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                    size: 22
                ),
                const SizedBox(width: 8),
                Text(
                  widget.hintText,
                  style: AppTextStyles.labelStyle.copyWith(
                      color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5)
                  ),
                ),
                if (widget.isRequired)
                  const Text(' *', style: TextStyle(color: AppColors.red)),
              ],
            ),
            selectedItemBuilder: (BuildContext context) {
              return _items.map<Widget>((Map<String, dynamic> item) {
                return Row(
                  children: [
                    Icon(
                        widget.prefixIcon,
                        color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                        size: 22
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getDisplayText(item),
                      style: TextStyle(
                          color: widget.enabled ? Colors.black : AppColors.grey.withOpacity(0.5)
                      ),
                    ),
                  ],
                );
              }).toList();
            },
            onChanged: widget.enabled && !widget.readOnly ? (String? newValue) {
              final selectedItem = _items.firstWhere(
                    (item) => _getDisplayText(item) == newValue,
                orElse: () => {},
              );

              setState(() {
                _selectedValue = selectedItem;
              });
              widget.onChanged(selectedItem);
            } : null,
            items: _items.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
              return DropdownMenuItem<String>(
                value: _getDisplayText(value),
                child: Text(
                  _getDisplayText(value),
                  style: TextStyle(
                      color: widget.enabled ? Colors.black : AppColors.grey.withOpacity(0.5)
                  ),
                ),
              );
            }).toList(),
            isExpanded: true,
            dropdownColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15),
          ),
        ),
      ),
    );
  }
}