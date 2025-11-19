import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class PhoneTextField extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController phoneNumberController;
  const PhoneTextField(
      {super.key, this.validator, required this.phoneNumberController});

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  String selectedCountry = '${Country(
    countryCode: 'ET',
    phoneCode: '+251',
    e164Sc: 23,
    geographic: true,
    level: 1,
    name: 'Ethiopia',
    example: '0911234567',
    displayName: 'Ethiopia (+251)',
    displayNameNoCountryCode: 'Ethiopia',
    e164Key: 'ET',
  ).flagEmoji} +251';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: widget.phoneNumberController,
      decoration: InputDecoration(
        border: Theme.of(context).inputDecorationTheme.border,
        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        prefixIcon: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.29,
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry =
                            '${country.flagEmoji} ${country.phoneCode}';
                        widget.phoneNumberController.text = country.phoneCode;
                      });
                    },
                  );
                },
                child: Row(
                  children: [
                    Text(
                      selectedCountry,
                      style: const TextStyle(
                        color: CustomColors.contentTertiary,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                    const SizedBox(width: 4),
                    Container(
                      width: 2,
                      height: 32,
                      color: CustomColors.info,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        hintText: "Phone Number",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
    );
  }
}
