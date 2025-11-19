import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/custom_colors.dart';
import '../theme/custom_typo.dart';

class CustomTextField extends StatefulWidget {
  final bool isObscure;
  final String? headerText;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Widget? prefix;
  final int? maxLines;
  final double? borderRadius;
  final bool? isDisabled;
  final Function(String)? onChanged;
  // add input formater
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  // add focus node
  final FocusNode? focusNode;
  final bool? autoFocus; // add auto focus
  // is disabled

  const CustomTextField({
    super.key,
    required this.isObscure,
    required this.headerText,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.fillColor,
    this.prefix,
    this.maxLines,
    this.borderRadius,
    this.onChanged,
    this.isDisabled,
    this.inputFormatter,
    this.maxLength,
    this.focusNode,
    this.autoFocus,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;
  @override
  void initState() {
    super.initState();
    isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.headerText != null && widget.headerText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:
                  Text(widget.headerText!, style: CustomTypography.bodyLarge),
            ),
          TextFormField(
            controller: widget.controller,
            obscureText: isObscure,
            cursorColor: CustomColors.bgLight,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            style: const TextStyle(
                color: CustomColors.bgLight,
                fontWeight: FontWeight.w300,
                fontSize: 16,
                decoration: TextDecoration.none,
                decorationThickness: 0),
            inputFormatters: widget.inputFormatter,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
            autofocus: widget.autoFocus ?? false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: CustomColors.info,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
                borderSide: const BorderSide(
                    color: CustomColors.primary), // Default border
              ),
              counterText: '',
              fillColor: widget.fillColor ?? CustomColors.primaryLight,
              filled: true,
              enabled: !(widget.isDisabled ?? false),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 24),

              prefixIcon: widget.prefix,
              prefixIconConstraints:
                  const BoxConstraints(maxHeight: 40, maxWidth: 40),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
                borderSide: const BorderSide(
                  color: CustomColors.primary,
                ), // Border when not focused
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
                borderSide: BorderSide(color: CustomColors.error),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 50),
                borderSide: BorderSide(color: CustomColors.error),
              ),

              // add eye icon to show password
              suffixIcon: widget.isObscure
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: CustomColors.contentTertiary,
                      ),
                    )
                  : null,
              errorStyle: const TextStyle(
                color: CustomColors.error, // Change to white
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              // focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
            ),
          )
        ],
      ),
    );
  }
}
