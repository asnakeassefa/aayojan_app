import 'dart:developer';

import 'package:aayojan/core/network/api_provider.dart';
import 'package:aayojan/core/utility/constants.dart';
import 'package:aayojan/core/widgets/custom_text_field.dart';
import 'package:aayojan/features/guest/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../errors/exceptions.dart';
import '../network/endpoints.dart';
import '../theme/custom_colors.dart';

class City {
  final String name;
  final String country;
  final String phoneNumber;

  City({required this.name, required this.country, required this.phoneNumber});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      country: json['country'],
    );
  }
}

class CustomTypeAhead extends StatefulWidget {
  final TextEditingController phoneController;
  final Function(UserData) onSelected;
  const CustomTypeAhead(
      {super.key, required this.phoneController, required this.onSelected});

  @override
  State<CustomTypeAhead> createState() => _CustomTypeAheadState();
}

class _CustomTypeAheadState extends State<CustomTypeAhead> {
  ApiService apiService = ApiService();
  Future<UserModel> fetchUserByPhone(String phone) async {
    // try {
    final response =
        await apiService.get('${Endpoints.getUserByPhone}?phone=$phone');
    return UserModel.fromJson(response.data);
    // } catch (e) {
    //   log(e.toString());
    //   if (e is ClientException) {
    //     rethrow;
    //   } else if (e is ServerException) {
    //     rethrow;
    //   } else {
    //     throw 'Something went wrong';
    //   }
    // }
  }

  // fetch data from api
  Future<List<UserData>?> fetchUser(String phone) async {
    // Simulate a network call
    log('here1');
    final response = await fetchUserByPhone(phone);
    return response.data;
  }

  // controller
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<UserData>(
      controller: widget.phoneController,
      suggestionsCallback: (search) async {
        if (search.length < 10) {
          return null;
        }
        log('here');
        return await fetchUser(search);
      },
      builder: (context, controller, focusNode) {
        return CustomTextField(
          isObscure: false,
          headerText: "",
          hintText: "Contact Number *",
          maxLength: 10,
          focusNode: focusNode,
          autoFocus: true,
          controller: widget.phoneController,
          inputFormatter: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.toString().isEmpty) {
              return "please enter your phone number";
            }
            return null;
          },
          onChanged: (value) {
            log(value);
          },
        );
      },
      itemBuilder: (context, user) {
        return Container(
          color: CustomColors.ligthPrimary,
          child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
          '${Endpoints.imageUrl}${user.profile ?? ""}'),
          radius: 16,
        ),
        title: Text(user.firstName ?? ""),
          ),
        );
      },
      hideWithKeyboard: false,
      onSelected: (user) {
        log(user.toString());
        widget.onSelected(user);
      },
      emptyBuilder: (context) => const SizedBox.shrink(),
    );
  }
}
