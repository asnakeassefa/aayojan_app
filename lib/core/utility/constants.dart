import 'package:aayojan/core/theme/custom_typo.dart';
import 'package:flutter/material.dart';

import '../theme/custom_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  const CustomText(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTypography.bodyLarge.copyWith(color: color),
    );
  }
}

List<DropdownMenuItem<String>> genderlist = const [
  DropdownMenuItem<String>(
    value: "-1",
    child: CustomText(
      'Gender',
      color: CustomColors.info,
    ),
  ),
  DropdownMenuItem<String>(
    value: "Male",
    child: CustomText('Male'),
  ),
  DropdownMenuItem<String>(
    value: "Female",
    child: CustomText('Female'),
  ),
];

// List<DropdownMenuItem<String>> relations = const [
//   DropdownMenuItem<String>(
//     value: "Hinduism",
//     child: CustomText("Hinduism"),
//   ),
//   DropdownMenuItem<String>(
//     value: "Muslim",
//     child: CustomText("Muslim"),
//   ),
//   DropdownMenuItem<String>(
//     value: "Christian",
//     child: CustomText("Christian"),
//   ),
//   DropdownMenuItem<String>(
//     value: "Sikh",
//     child: CustomText("Sikh"),
//   ),
// ];

// List<DropdownMenuItem<String>> category = const [
//   DropdownMenuItem<String>(
//     value: "Paternal",
//     child: CustomText("Paternal"),
//   ),
//   DropdownMenuItem<String>(
//     value: "Maternal",
//     child: CustomText("Maternal"),
//   ),
//   DropdownMenuItem<String>(
//     value: "Friends",
//     child: CustomText("Friends"),
//   ),
//   DropdownMenuItem<String>(
//     value: "Colleagues",
//     child: CustomText("Colleagues"),
//   ),
//   DropdownMenuItem<String>(
//     value: "Neighbour’s",
//     child: CustomText("Neighbour’s"),
//   ),
// ];

List<DropdownMenuItem<String>> samaj = const [
  DropdownMenuItem<String>(
    value: "Jain (Digambar)",
    child: CustomText("Jain (Digambar)"),
  ),
  DropdownMenuItem<String>(
    value: "Jain (Shwetambar)",
    child: CustomText("Jain (Shwetambar)"),
  ),
  DropdownMenuItem<String>(
    value: "Agrawal",
    child: CustomText("Agrawal"),
  ),
  DropdownMenuItem<String>(
    value: "Rajput",
    child: CustomText("Rajput"),
  ),
];

List<DropdownMenuItem<String>> eventType = const [
  DropdownMenuItem<String>(
    value: "-1",
    child: CustomText("Event Type", color: CustomColors.info),
  ),
  DropdownMenuItem<String>(
    value: "Wedding",
    child: CustomText("Wedding"),
  ),
  DropdownMenuItem<String>(
    value: "Ring Ceremony",
    child: CustomText("Ring Ceremony"),
  ),
  DropdownMenuItem<String>(
    value: "BirthDay Party",
    child: CustomText("BirthDay Party"),
  ),
  DropdownMenuItem<String>(
    value: "Retirement Party",
    child: CustomText("Retirement Party"),
  ),
  DropdownMenuItem<String>(
    value: "Office Party",
    child: CustomText("Office Party"),
  ),
  DropdownMenuItem<String>(
    value: "Baby Shower",
    child: CustomText("Baby Shower"),
  ),
  DropdownMenuItem<String>(
    value: "Reception",
    child: CustomText("Reception"),
  ),
  DropdownMenuItem<String>(
    value: "Inauguration",
    child: CustomText("Inauguration"),
  ),
  DropdownMenuItem<String>(
    value: "Wedding Anniversary",
    child: CustomText("Wedding Anniversary"),
  ),
  DropdownMenuItem<String>(
    value: "Silver Jubilee",
    child: CustomText("Silver Jubilee"),
  ),
  DropdownMenuItem<String>(
    value: "Golden Jubilee",
    child: CustomText("Golden Jubilee"),
  ),
  DropdownMenuItem<String>(
    value: "Pooja",
    child: CustomText("Pooja"),
  ),
  DropdownMenuItem<String>(
    value: "Others",
    child: CustomText("Others"),
  ),

];
List<DropdownMenuItem<String>> familymembers = const [
  DropdownMenuItem<String>(
    value: "Father",
    child: CustomText("Father"),
  ),
  DropdownMenuItem<String>(
    value: "Mother",
    child: CustomText("Brother"),
  ),
  DropdownMenuItem<String>(
    value: "Brother",
    child: CustomText("Brother"),
  ),
  DropdownMenuItem<String>(
    value: "Sister",
    child: CustomText("Sister"),
  ),
];

// number of kids in family dropdown
List<DropdownMenuItem<String>> kids = const [
  DropdownMenuItem<String>(
    value: "0",
    child: CustomText("0"),
  ),
  DropdownMenuItem<String>(
    value: "1",
    child: CustomText("1"),
  ),
  DropdownMenuItem<String>(
    value: "2",
    child: CustomText("2"),
  ),
  DropdownMenuItem<String>(
    value: "3",
    child: CustomText("3"),
  ),
  DropdownMenuItem<String>(
    value: "4",
    child: CustomText("4"),
  ),
  DropdownMenuItem<String>(
    value: "5",
    child: CustomText("5"),
  ),
  DropdownMenuItem<String>(
    value: "6",
    child: CustomText("6"),
  ),
  DropdownMenuItem<String>(
    value: "7",
    child: CustomText("7"),
  ),
  DropdownMenuItem<String>(
    value: "8",
    child: CustomText("8"),
  ),
  DropdownMenuItem<String>(
    value: "9",
    child: CustomText("9"),
  ),
  DropdownMenuItem<String>(
    value: "10",
    child: CustomText("10"),
  ),
];

List<DropdownMenuItem<String>> timeOfDay = const [
  DropdownMenuItem<String>(
    value: "-1",
    child: CustomText("Time of Day", color: CustomColors.info),
  ),
  DropdownMenuItem<String>(
    value: "morning",
    child: CustomText("Morning"),
  ),
  DropdownMenuItem<String>(
    value: "afternoon",
    child: CustomText("Afternoon"),
  ),
  DropdownMenuItem<String>(
    value: "evening",
    child: CustomText("Evening"),
  ),
  DropdownMenuItem<String>(
    value: "night",
    child: CustomText("Night"),
  ),
];

List<DropdownMenuItem<String>> guestResponsePrefernce = const [
  DropdownMenuItem<String>(
    value: 'Accept With Thanks',
    child: CustomText('Accept With Thanks'),
  ),
  DropdownMenuItem<String>(
    value: 'Not Sure To Attend',
    child: CustomText('Not Sure To Attend'),
  ),
  DropdownMenuItem<String>(
    value: 'Unable To Attend',
    child: CustomText('Unable To Attend'),
  ),
];


