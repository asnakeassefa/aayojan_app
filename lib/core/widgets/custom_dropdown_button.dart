import 'package:flutter/material.dart';
import '../theme/custom_colors.dart';
import '../theme/custom_typo.dart';

class CustomDropdownButton<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>> items;
  final String title;
  final T? initVal;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.title,
    this.onChanged,
    this.initVal,
    this.validator,
  });

  @override
  State<CustomDropdownButton<T>> createState() =>
      _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        fillColor: CustomColors.primaryLight,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none, // No border when valid
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: CustomColors.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: CustomColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: CustomColors.error, width: 2),
        ),
        errorStyle: const TextStyle(
          color: CustomColors.error,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      hint: Text(
        widget.title,
        style: CustomTypography.subHeadLarge.copyWith(
          color: CustomColors.info,
          fontWeight: FontWeight.w400,
        ),
      ),
      iconEnabledColor: CustomColors.bgLight,
      dropdownColor: CustomColors.primary,
      items: widget.items,
      value: widget.initVal,
      menuMaxHeight: 300,
      borderRadius: BorderRadius.circular(24),
      onChanged: widget.onChanged,
      style: CustomTypography.bodySmall.copyWith(
        color: CustomColors.bgLight,
        fontWeight: FontWeight.w300,
        fontSize: 20,
      ),
      validator: widget.validator ??
          (value) {
            if (value == null) {
              return "${widget.title} is required";
            }
            return null;
          },
    );
  }
}
